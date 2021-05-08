import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/DashBoard.dart';
import 'DashBoard.dart';
import 'Widgets/ProgressBar.dart';
import 'Widgets/TextFieldShadow.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  load('user_id').then(
    (value) => runApp(
      MaterialApp(home: value == '-1' ? MyApp() : DashBoard()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'CMS Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController emailFieldController = new TextEditingController(),
      passFieldController = new TextEditingController();
  bool validateEmail = false, validatePassword = false, loading = false;

  @override
  Widget build(BuildContext context) {
    // load('client_id').then((value) {
    //   if (value != '-1') {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => DashBoard()));
    //   }
    // });

    final emailField = Stack(children: [
      TextFieldShadow(),
      Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: TextField(
          controller: emailFieldController,
          obscureText: false,
          style: style,
          onChanged: (text) {
            setState(() {
              validateEmail = false;
            });
          },
          decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.2),
            filled: true,
            errorText: validateEmail ? 'Username is required' : null,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
    ]); //Email Text Field
    final passwordField = Stack(
      children: [
        TextFieldShadow(),
        TextField(
          controller: passFieldController,
          obscureText: true,
          style: style,
          onChanged: (text) {
            setState(() {
              validatePassword = false;
            });
          },
          decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.2),
            filled: true,
            errorText: validatePassword ? 'Password is required' : null,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      ],
    ); // Password Text Field
    final loginButton = Material(
      elevation: 5.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff0065a3).withOpacity(0.9),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => checkInfo(),
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ); //Login Button

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/background1.jpg"),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100.0,
                          child: Image.asset(
                            "assets/image/DesignLogo.png",
                            fit: BoxFit.contain,
                          ), // Image setting
                        ),

                      Text(
                'Satellite Managment System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),

                        SizedBox(height: 20.0),
                        Text('Welcome to Comdelta Tracking System',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 20.0),
                        emailField,
                        SizedBox(height: 20.0),
                        passwordField,
                        SizedBox(height: 25.0),
                        loginButton,
                        SizedBox(height: 100.0),
                      ],
                    ),
                  ), // Setting for Text Field, Password Field and Login Button
                ),
              ),
              Center(
                child: Visibility(
                  child: CircularProgressIndicatorApp(),
                  visible: loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkInfo() async {
    if (emailFieldController.text.isEmpty) {
      setState(() {
        validateEmail = true;
      });
      return;
    }

    if (passFieldController.text.isEmpty) {
      setState(() {
        validatePassword = true;
      });
      return;
    }
    setState(() => loading = true);

    String msg = '';
    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/login.php'),
        body: {
          'email': emailFieldController.text,
          'password': passFieldController.text
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        String value = json.decode(response.body);
        if (value != '-1') {
          List<String> result = value.split(',');
          if (result.length > 1) {
            save('profile_pic', '-1');
            save('client_id', result[0]);
            save('user_id', result[1]);
            msg = 'Logged in successfully';
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DashBoard()));
          } else {
            msg = 'Something wrong with the server!';
          }
        } else {
          msg = 'Email or password is incorrect';
        }
      } else {
        msg = getResponseError(response);
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
      setState(() => loading = false);
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: 'Error: ' + error.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
      setState(() => loading = false);
    });
  }

  String getResponseError(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        return (response.body.toString());
      case 401:
        return (response.body.toString());
      case 403:
        return (response.body.toString());
      case 500:
      default:
        return 'Error occurred while Communication with Server with StatusCode: ${response.statusCode}';
    }
  }
}

Future<String> load(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '-1';
}

void save(String key, String data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}
