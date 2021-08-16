import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Widgets/ProgressBars/ProgressBar.dart';
import '../../Widgets/SideDrawers/SideDrawer.dart';
import '../../Widgets/AppBars/CustomeAppBar.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Sending Feedback'),
    duration: Duration(seconds: 60),
  );

  TextEditingController nameController = new TextEditingController(),
      subjectController = new TextEditingController(),
      emailFrController = new TextEditingController(),
      emailToController = new TextEditingController()
        ..text =
            "info@comdelta.com.my", //info@comdelta.com.my,yousfzaghlol@gmail.com
      messageController = new TextEditingController();

  bool loading = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

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
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: PreferredSize(
          child: CustomAppBarBack(context, 'Feedback'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 670,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          heightFactor: 2,
                          child: Text(
                            'Feedback Report',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: form(context),
                          // "Edotco@comdelta.com","Edotco Comdelta","info@comdelta.com.my"
                        ),
                      ],
                    ),
                  ),
                ),
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
    );
  }

  Widget form(BuildContext context) {
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
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: emailFrController.text,
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
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              TextFormField(
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: emailToController.text,
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
                  if (nameController.text.isNotEmpty &&
                      subjectController.text.isNotEmpty &&
                      messageController.text.isNotEmpty) {
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

  Future<void> getInfo() async {
    load('user_id').then((value) =>
        value != '-1' ? sendPost(value) : toast('User was not found!'));
  }

  void sendPost(String userId) {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/getUserProfile.php'),
        body: {
          'user_id': userId,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        String value = json.decode(response.body);
        if (value != '-1') {
          List<String> result = value.split(',');
          if (result.length > 3) {
            setState(() {
              nameController.text = result[0] + ' ' + result[1];
              emailFrController.text = result[2];
            });
          } else {
            toast('Something wrong with the server!');
          }
        } else {
          toast('User does not exist');
        }

        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get user info");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void sendFeedBack() {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/sendFeedBack.php'),
        body: {
          'from': nameController.text,
          'to': emailToController.text,
          'subject': subjectController.text,
          'message': messageController.text,
        }).then((response) {
      if (response.statusCode == 200) {
        if (response.body.toLowerCase().contains("message sent")) {
          toast("Feedback has been sent successfully!");
        } else {
          toast('Error while sending Feedback');
        }
      } else {
        throw Exception("Error with the server");
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }).onError((error, stackTrace) {
      toast('Failure');
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
