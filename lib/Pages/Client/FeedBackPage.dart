import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:http/http.dart' as http;
import '../../public.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  // final _formKey = GlobalKey<FormState>();
  // bool subjectError = false, messageError = false;
  final snackBar = SnackBar(
    content: Text('Sending Feedback'),
    duration: Duration(seconds: 60),
  );
  String sendTo = "info@comdelta.com.my";
  TextEditingController
      // nameController = new TextEditingController(),
      subjectController = new TextEditingController(),
      // emailFrController = new TextEditingController()..text = user.userName,
      // emailToController = new TextEditingController()
      //   ..text =
      //       "info@comdelta.com.my", //info@comdelta.com.my,yousfzaghlol@gmail.com
      messageController = new TextEditingController();

  // bool loading = true;
  @override
  void initState() {
    getUser();
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
        backgroundColor: Color(0xFFFAFAFA),
        appBar: PreferredSize(
          child: CustomAppBarBack(context, 'Feedback'),
          preferredSize: const Size.fromHeight(50),
        ),
        // drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          backgroundColor: PrimaryColor,
          onPressed: sendFeedBack,
        ),
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "From",
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user.userName,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                height: 2,
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "To",
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      sendTo,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              Divider(
                thickness: 2,
                height: 2,
              ),

              TextField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                controller: subjectController,
                decoration: InputDecoration(
                    // errorText: (subjectError) ? "Please Enter Subject" : null,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Subject"),
              ),

              Divider(
                thickness: 2,
                height: 2,
              ),

              TextField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                controller: messageController,
                decoration: InputDecoration(
                    // errorText: (messageError) ? "Please Enter Message" : null,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Compose email"),
              ),
              SizedBox(
                height: 60,
              ),
              //
              // Divider(
              //   thickness: 2,
              //   height: 2,
              // ),
              //
              // RichText(
              //   text: TextSpan(
              //     text: 'Email',
              //     style: TextStyle(fontSize: 16.0, color: Colors.grey),
              //     children: [
              //       TextSpan(
              //         text: ' *',
              //         style: TextStyle(color: Colors.red, fontSize: 16.0),
              //       ),
              //     ],
              //   ),
              // ),
              // TextFormField(
              //   enabled: false,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     hintText: emailFrController.text,
              //     contentPadding: EdgeInsets.all(15),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(0.0),
              //     ),
              //   ),
              // ), //Email text field
              //
              // SizedBox(height: 15),
              // RichText(
              //   text: TextSpan(
              //     text: 'Name',
              //     style: TextStyle(fontSize: 16.0, color: Colors.black),
              //     children: [
              //       TextSpan(
              //         text: ' *',
              //         style: TextStyle(color: Colors.red, fontSize: 16.0),
              //       ),
              //     ],
              //   ),
              // ),
              // TextFormField(
              //   controller: nameController,
              //   // The validator receives the text that the user has entered.
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a correct name';
              //     }
              //     return null;
              //   },
              //   autofillHints: [AutofillHints.name],
              //   keyboardType: TextInputType.name,
              //   decoration: InputDecoration(
              //     hintText: 'Name',
              //     contentPadding: EdgeInsets.all(15),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(0.0),
              //     ),
              //   ),
              // ), //Name text field
              //
              // SizedBox(height: 15),
              // RichText(
              //   text: TextSpan(
              //     text: 'Feedback Subject',
              //     style: TextStyle(fontSize: 16.0, color: Colors.black),
              //     children: [
              //       TextSpan(
              //         text: ' *',
              //         style: TextStyle(color: Colors.red, fontSize: 16.0),
              //       ),
              //     ],
              //   ),
              // ),
              // TextFormField(
              //   controller: subjectController,
              //   // The validator receives the text that the user has entered.
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter some text';
              //     }
              //     return null;
              //   },
              //   keyboardType: TextInputType.text,
              //   decoration: InputDecoration(
              //     hintText: 'Subject',
              //     contentPadding: EdgeInsets.all(15),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(0.0),
              //     ),
              //   ),
              // ), // Feedback Subject Field
              //
              // SizedBox(height: 15),
              // RichText(
              //   text: TextSpan(
              //     text: 'Feedback Message',
              //     style: TextStyle(fontSize: 16.0, color: Colors.black),
              //     children: [
              //       TextSpan(
              //         text: ' *',
              //         style: TextStyle(color: Colors.red, fontSize: 16.0),
              //       ),
              //     ],
              //   ),
              // ),
              // TextFormField(
              //   controller: messageController,
              //   // The validator receives the text that the user has entered.
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter some text';
              //     }
              //     return null;
              //   },
              //   keyboardType: TextInputType.text,
              //   decoration: InputDecoration(
              //     hintText: 'Message',
              //     contentPadding: EdgeInsets.all(15),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(0.0),
              //     ),
              //   ),
              // ), // Feedback Message
              //
              // SizedBox(height: 15),
              // RichText(
              //   text: TextSpan(
              //     text: 'To Email Address',
              //     style: TextStyle(fontSize: 16.0, color: Colors.grey),
              //     children: [
              //       TextSpan(
              //         text: ' *',
              //         style: TextStyle(color: Colors.red, fontSize: 16.0),
              //       ),
              //     ],
              //   ),
              // ),
              // TextFormField(
              //   enabled: false,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     hintText: emailToController.text,
              //     contentPadding: EdgeInsets.all(15),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(0.0),
              //     ),
              //   ),
              // ), //Email text Field
            ],
          ),
        ),
      ),
    );
  }

  // Widget form(BuildContext context) {
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       children: <Widget>[
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             RichText(
  //               text: TextSpan(
  //                 text: 'Email',
  //                 style: TextStyle(fontSize: 16.0, color: Colors.grey),
  //                 children: [
  //                   TextSpan(
  //                     text: ' *',
  //                     style: TextStyle(color: Colors.red, fontSize: 16.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextFormField(
  //               enabled: false,
  //               keyboardType: TextInputType.emailAddress,
  //               decoration: InputDecoration(
  //                 hintText: emailFrController.text,
  //                 contentPadding: EdgeInsets.all(15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(0.0),
  //                 ),
  //               ),
  //             ), //Email text field
  //
  //             SizedBox(height: 15),
  //             RichText(
  //               text: TextSpan(
  //                 text: 'Name',
  //                 style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                 children: [
  //                   TextSpan(
  //                     text: ' *',
  //                     style: TextStyle(color: Colors.red, fontSize: 16.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextFormField(
  //               controller: nameController,
  //               // The validator receives the text that the user has entered.
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter a correct name';
  //                 }
  //                 return null;
  //               },
  //               autofillHints: [AutofillHints.name],
  //               keyboardType: TextInputType.name,
  //               decoration: InputDecoration(
  //                 hintText: 'Name',
  //                 contentPadding: EdgeInsets.all(15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(0.0),
  //                 ),
  //               ),
  //             ), //Name text field
  //
  //             SizedBox(height: 15),
  //             RichText(
  //               text: TextSpan(
  //                 text: 'Feedback Subject',
  //                 style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                 children: [
  //                   TextSpan(
  //                     text: ' *',
  //                     style: TextStyle(color: Colors.red, fontSize: 16.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextFormField(
  //               controller: subjectController,
  //               // The validator receives the text that the user has entered.
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter some text';
  //                 }
  //                 return null;
  //               },
  //               keyboardType: TextInputType.text,
  //               decoration: InputDecoration(
  //                 hintText: 'Subject',
  //                 contentPadding: EdgeInsets.all(15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(0.0),
  //                 ),
  //               ),
  //             ), // Feedback Subject Field
  //
  //             SizedBox(height: 15),
  //             RichText(
  //               text: TextSpan(
  //                 text: 'Feedback Message',
  //                 style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                 children: [
  //                   TextSpan(
  //                     text: ' *',
  //                     style: TextStyle(color: Colors.red, fontSize: 16.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextFormField(
  //               controller: messageController,
  //               // The validator receives the text that the user has entered.
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter some text';
  //                 }
  //                 return null;
  //               },
  //               keyboardType: TextInputType.text,
  //               decoration: InputDecoration(
  //                 hintText: 'Message',
  //                 contentPadding: EdgeInsets.all(15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(0.0),
  //                 ),
  //               ),
  //             ), // Feedback Message
  //
  //             SizedBox(height: 15),
  //             RichText(
  //               text: TextSpan(
  //                 text: 'To Email Address',
  //                 style: TextStyle(fontSize: 16.0, color: Colors.grey),
  //                 children: [
  //                   TextSpan(
  //                     text: ' *',
  //                     style: TextStyle(color: Colors.red, fontSize: 16.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             TextFormField(
  //               enabled: false,
  //               keyboardType: TextInputType.emailAddress,
  //               decoration: InputDecoration(
  //                 hintText: emailToController.text,
  //                 contentPadding: EdgeInsets.all(15),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(0.0),
  //                 ),
  //               ),
  //             ), //Email text Field
  //           ],
  //         ),
  //         SizedBox(height: 20),
  //         Container(
  //           width: 180,
  //           height: 50,
  //           child: ElevatedButton(
  //             onPressed: () {
  //               // Validate returns true if the form is valid, or false otherwise.
  //               if (_formKey.currentState.validate()) {
  //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //                 if (nameController.text.isNotEmpty &&
  //                     subjectController.text.isNotEmpty &&
  //                     messageController.text.isNotEmpty) {
  //                   sendFeedBack();
  //                 }
  //               }
  //             },
  //             child: Text(
  //               'Send',
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ),
  //           // Add TextFormFields and ElevatedButton here.
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Future<void> getInfo() async {
  //   load('user_id').then((value) =>
  //       value != '-1' ? sendPost(value) : toast('User was not found!'));
  // }
  //
  // void sendPost(String userId) {
  //   http.post(
  //       Uri.parse('http://103.18.247.174:8080/AmitProject/getUserProfile.php'),
  //       body: {
  //         'user_id': userId,
  //       }).then((response) {
  //     if (response.statusCode == 200) {
  //       // ignore: deprecated_member_use
  //       String value = json.decode(response.body);
  //       if (value != '-1') {
  //         List<String> result = value.split(',');
  //         if (result.length > 3) {
  //           setState(() {
  //             nameController.text = result[0] + ' ' + result[1];
  //             emailFrController.text = result[2];
  //           });
  //         } else {
  //           toast('Something wrong with the server!');
  //         }
  //       } else {
  //         toast('User does not exist');
  //       }
  //
  //       setState(() {
  //         loading = false;
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       throw Exception("Unable to get user info");
  //     }
  //   }).onError((error, stackTrace) {
  //     setState(() {
  //       loading = false;
  //     });
  //     toast('Error: ' + error.message);
  //   });
  // }

  Future<void> getUser() async {
    await RemoteApi.getUserInfo().then((value) => setState(() => user));
  }

  Future<void> sendFeedBack() async {
    if (subjectController.text.isEmpty) {
      toast("Please Enter Subject");
      return;
    }
    if (messageController.text.isEmpty) {
      toast("Please Enter Message");
      return;
    }
    try {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final response = await http.post(
          Uri.parse('http://103.18.247.174:8080/AmitProject/sendFeedBack.php'),
          body: {
            'from': user.fulName,
            'to': sendTo,
            'subject': subjectController.text,
            'message': messageController.text,
          });
      if (response.statusCode == 200) {
        if (response.body.toLowerCase().contains("message sent")) {
          toast("Feedback has been sent successfully!");
          RemoteApi.notifyAdmins(user.fulName, messageController.text);
        } else {
          toast('Error while sending Feedback');
          // print(response.body);
          RemoteApi.notifyAdmins(user.fulName, messageController.text);
        }
      } else {
        RemoteApi.notifyAdmins(user.fulName, messageController.text);
        toast(getResponseError(response));
      }
    } catch (error) {
      toast(error.toString());
      RemoteApi.notifyAdmins(user.fulName, messageController.text);
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

// Future<String> load(String key) async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString(key) ?? '-1';
// }
//
// void toast(String msg) {
//   Fluttertoast.showToast(
//     msg: msg,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 1,
//   );
// }
}
