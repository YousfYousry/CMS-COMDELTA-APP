import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/DashBoard.dart';

import 'DashBoard.dart';

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
        ));
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
  @override
  Widget build(BuildContext context) {
    
    final emailField = Material(
      child: TextField(
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)))),
      elevation: 10.0,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(32.0),
    ); //Email Text Field 

    final passwordField = Material(
      child: TextField(
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)))),
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashBoard()));
            },
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ))); //Login Button

    return Scaffold(
        body: Center(
            child: Container(
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
      )), // Setting for Text Field, Password Field and Login Button
    )))); 
  }
}
