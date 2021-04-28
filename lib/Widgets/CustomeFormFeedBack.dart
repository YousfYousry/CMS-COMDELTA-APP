import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedBackForm extends StatefulWidget {
  @override
  _FeedBackFormState createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController(),
      subjectController = new TextEditingController(),
      messageController = new TextEditingController();

  final snackBar = SnackBar(
    content: Text('Sending Feedback'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vaild email';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
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
                  text: 'Name',
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
                controller: nameController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a correct name';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.name],
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Name text field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Feedback Subject',
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
                controller: subjectController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Subject',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // Feedback Subject Field

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Feedback Message',
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
                controller: messageController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Message',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), // Feedback Message

              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'To Email Address',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a vaild email';
                  }
                  return null;
                },
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ), //Email text Field
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 180,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  if(nameController.text.isNotEmpty&&subjectController.text.isNotEmpty&&messageController.text.isNotEmpty) {
                    sendFeedBack();
                  }
                }
              },
              child: Text(
                'Send',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Add TextFormFields and ElevatedButton here.
          ),
        ],
      ),
    );
  }

  // void getUser() {
  //   load('user_id').then((value) =>
  //   value != '-1' ? sendPost(value) : toast('User was not found!'));
  // }


  void sendFeedBack() {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/sendFeedBack.php'),
        body: {
          'from': nameController.text,
          'to': 'yousfzaghlol@gmail.com',
          'subject':subjectController.text,
          'message':messageController.text,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        String value = json.decode(response.body);
        if (value.contains("Message sent")) {
          toast("Feedback has been sent successfully!");
        } else {
          toast('Error while sending Feedback');
        }
      } else {
        throw Exception("Error with the server");
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
      timeInSecForIosWeb: 1,
    );
  }
}
