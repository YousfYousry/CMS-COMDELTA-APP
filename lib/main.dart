import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/DashBoard.dart';
import 'DashBoard.dart';
import 'ProgressBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'CMS Login UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'CMS Login'),
      ),
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
  bool validateEmail = false, validatePassword = false,loading=false;

  @override
  Widget build(BuildContext context) {
    final emailField = Material(
      child: TextField(
        controller: emailFieldController,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          errorText: validateEmail ? 'Email Can\'t Be Empty' : null,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
      elevation: 10.0,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(32.0),
    ); //Email Text Field

    final passwordField = Material(
      child: TextField(
        controller: passFieldController,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          errorText: validatePassword ? 'Password Can\'t Be Empty' : null,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      elevation: 10.0,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(32.0),
    ); // Password Text Field

    final loginButton = Material(
      elevation: 10.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff0065a3),
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

    return Scaffold(
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
                        "assets/image/logo.png",
                        fit: BoxFit.contain,
                      ), // Image setting
                    ),
                    SizedBox(height: 20.0),
                    Text('Welcome to Comdelta Tracking System',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
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
    );
  }

  Future<void> checkInfo() async {
    setState(() => loading=true);
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

    String msg = '';
    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/login.php'),
        body: {
          'email': emailFieldController.text,
          'password': passFieldController.text
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        int value = json.decode(response.body);
        if (value == 1) {
          msg = 'Logged in successfully';
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DashBoard()));
        } else if (value == 0) {
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
      setState(() => loading=false);
    });

    // Map data = {
    //   'email': 'user@comdelta.com',
    //   'password': '2181dab55acfd8d519301d48e66b1a8c'
    // };
    //
    // String body = json.encode(data);
    // http.Response response = await http.post(
    //   Uri.parse('http://103.18.247.174:8080/AmitProject/login.php'),
    //   headers: {"Content-Type": "application/json"},
    //   body: body,
    // );
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
