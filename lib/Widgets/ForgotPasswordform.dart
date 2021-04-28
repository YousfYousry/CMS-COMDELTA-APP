import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String emailError = 'Email is required!',
      oPassError = 'Old password is required!',
      passError = 'New password is required!',
      rPassError = 'Re-Type password is required!';
  bool validateEmail = false,
      validateOPass = false,
      validatePass = false,
      validateRPass = false;
  TextEditingController emailFieldController = new TextEditingController(),
      oPassFieldController = new TextEditingController(),
      passFieldController = new TextEditingController(),
      rPassFieldController = new TextEditingController();

  final snackBar = SnackBar(
    content: Text('Changing the password'),
    duration: Duration(seconds: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Old information',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: 'Email',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a vaild email';
                //   }
                //   return null;
                // },
                controller: emailFieldController,
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  setState(() {
                    validateEmail = false;
                  });
                },
                decoration: InputDecoration(
                  errorText: validateEmail ? emailError : null,
                  hintText: 'Email Address',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Email text field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Old Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a correct password';
                //   }
                //   return null;
                // },
                controller: oPassFieldController,
                obscureText: true,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    validateOPass = false;
                  });
                },
                decoration: InputDecoration(
                  errorText: validateOPass ? oPassError : null,
                  hintText: 'Old Password',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Old Password field

              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'New information',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: 'New Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter a vaild passowrd';
                //   }
                //   return null;
                // },
                controller: passFieldController,
                obscureText: true,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    validatePass = false;
                  });
                },
                decoration: InputDecoration(
                  errorText: validatePass ? passError : null,
                  hintText: 'New Password',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // New Password Field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Re-Type Password',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter the same passowrd';
                //   }
                //   return null;
                // },
                controller: rPassFieldController,
                obscureText: true,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                onChanged: (text) {
                  setState(() {
                    validateRPass = false;
                  });
                },
                decoration: InputDecoration(
                  errorText: validateRPass ? rPassError : null,
                  hintText: 'Re-Type Password',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // Re-Type Password Field
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => changePass(),
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Add TextFormFields and ElevatedButton here.
          ),
        ],
      ),
    );
  }

  void changePass() {
    if (emailFieldController.text.isEmpty) {
      emailError = 'Email is required!';
      setState(() => validateEmail = true);
      return;
    }

    if (oPassFieldController.text.isEmpty) {
      oPassError = 'Old password is required!';
      setState(() => validateOPass = true);
      return;
    }

    if (passFieldController.text.isEmpty) {
      passError = 'New password is required!';
      setState(() => validatePass = true);
      return;
    }

    if (rPassFieldController.text.isEmpty) {
      rPassError = 'Re-Type password is required!';
      setState(() => validateRPass = true);
      return;
    }

    if (passFieldController.text.compareTo(rPassFieldController.text) != 0) {
      setState(() {
        passError = 'Password doesn\'t match!';
        rPassError = 'Password doesn\'t match!';
        validatePass = true;
        validateRPass = true;
      });
      return;
    }

    setState(() {
      validateEmail = false;
      validateOPass = false;
      validatePass = false;
      validateRPass = false;
    });

    if (oPassFieldController.text.compareTo(passFieldController.text) == 0) {
      setState(() {
        toast('Password has been updated successfully');
        return;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    load('user_id').then((value) => value != '-1'
        ? sendPostToUpdatePass(value)
        : toast('User was not found!'));
  }

  void sendPostToUpdatePass(String userId) {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/changePass.php'),
        body: {
          'user_id': userId,
          'email': emailFieldController.text,
          'password': oPassFieldController.text,
          'new_password': passFieldController.text,
        }).then((response) {
      if (response.statusCode == 200) {
        if (json.decode(response.body) > 0) {
          toast('Password has been updated successfully');
        } else {
          toast('You are not authorised person !');
        }
      } else {
        toast('Something wrong with the server!');
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }).onError((error, stackTrace) {
      toast('Error: ' + error.message);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '-1';
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}
