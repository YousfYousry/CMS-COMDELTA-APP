import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/public.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';

// import '../Widgets/AppBars/CustomeAppBar.dart';
// import '../Widgets/SideDrawers/SideDrawer.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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

  // var profileImage = DecorationImage(
  //   image: NetworkImage('http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png'),
  // );

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
        backgroundColor: Color(0XFFFAFAFA),
        appBar: PreferredSize(
          child: CustomAppBarBack(context, 'Change Password'),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: PrimaryColor,
          onPressed: changePass,
        ),
        // drawer: SideDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 110,
                        width: 110,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: user.logo,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.34),
                              offset: Offset(0, 5),
                              blurRadius: 15,
                              spreadRadius: 3,
                            )
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      Text(
                        user.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Text(
                //   'Old information',
                //   style: TextStyle(fontSize: 22),
                //   textAlign: TextAlign.center,
                // ),
                // SmartField(
                //   controller: emailFieldController,
                //   keyboardType: TextInputType.emailAddress,
                //   onChanged: (text) {
                //     setState(() {
                //       validateEmail = false;
                //     });
                //   },
                //   title: 'Email Address',
                //   errorText: validateEmail ? emailError : null,
                //   filled: false,
                //   opacity: 0.5,
                // ),
                SmartField(
                  controller: oPassFieldController,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (text) {
                    setState(() {
                      validateOPass = false;
                    });
                  },
                  title: 'Old Password',
                  errorText: validateOPass ? oPassError : null,
                  filled: false,
                  opacity: 0.5,
                  obscureText: true,
                ),

                // Text(
                //   'New information',
                //   style: TextStyle(fontSize: 22),
                //   textAlign: TextAlign.center,
                // ),
                // Divider(
                //   thickness: 2,
                //   color: Colors.black.withOpacity(0.3),
                // ),
                SizedBox(
                  height: 10,
                ),
                SmartField(
                  controller: passFieldController,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (text) {
                    setState(() {
                      validatePass = false;
                    });
                  },
                  title: 'New Password',
                  errorText: validatePass ? passError : null,
                  filled: false,
                  opacity: 0.5,
                  obscureText: true,
                ),
                SmartField(
                  controller: rPassFieldController,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (text) {
                    setState(() {
                      validateRPass = false;
                    });
                  },
                  title: 'Re-Type Password',
                  errorText: validateRPass ? rPassError : null,
                  titled: false,
                  filled: false,
                  opacity: 0.5,
                  obscureText: true,
                ),
                SizedBox(
                  height: 60,
                ),

                // Center(
                //   heightFactor: 2,
                //   child: Text(
                //     'Change your information',
                //     style: TextStyle(
                //         fontSize: 22, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // Divider(),
                // Container(
                //   padding: EdgeInsets.all(10),
                //   child: Column(
                //     children: <Widget>[
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           // Center(
                //           //   child: Text(
                //           //     'Old information',
                //           //     style: TextStyle(fontSize: 22),
                //           //     textAlign: TextAlign.center,
                //           //   ),
                //           // ),
                //           // SizedBox(
                //           //   height: 10,
                //           // ),
                //           // RichText(
                //           //   text: TextSpan(
                //           //     text: 'Email',
                //           //     style: TextStyle(fontSize: 16.0, color: Colors.black),
                //           //     children: [
                //           //       TextSpan(
                //           //         text: ' *',
                //           //         style: TextStyle(color: Colors.red, fontSize: 16.0),
                //           //       ),
                //           //     ],
                //           //   ),
                //           // ),
                //           // TextFormField(
                //           //   // The validator receives the text that the user has entered.
                //           //   // validator: (value) {
                //           //   //   if (value == null || value.isEmpty) {
                //           //   //     return 'Please enter a vaild email';
                //           //   //   }
                //           //   //   return null;
                //           //   // },
                //           //   controller: emailFieldController,
                //           //   autofillHints: [AutofillHints.email],
                //           //   keyboardType: TextInputType.emailAddress,
                //           //   onChanged: (text) {
                //           //     setState(() {
                //           //       validateEmail = false;
                //           //     });
                //           //   },
                //           //   decoration: InputDecoration(
                //           //     errorText: validateEmail ? emailError : null,
                //           //     hintText: 'Email Address',
                //           //     contentPadding: EdgeInsets.all(15),
                //           //     border: OutlineInputBorder(
                //           //       borderRadius: BorderRadius.circular(0.0),
                //           //     ),
                //           //   ),
                //           // ), //Email text field
                //           // SizedBox(height: 15),
                //           // RichText(
                //           //   text: TextSpan(
                //           //     text: 'Old Password',
                //           //     style:
                //           //         TextStyle(fontSize: 16.0, color: Colors.black),
                //           //     children: [
                //           //       TextSpan(
                //           //         text: ' *',
                //           //         style: TextStyle(
                //           //             color: Colors.red, fontSize: 16.0),
                //           //       ),
                //           //     ],
                //           //   ),
                //           // ),
                //           // TextFormField(
                //           //   // The validator receives the text that the user has entered.
                //           //   // validator: (value) {
                //           //   //   if (value == null || value.isEmpty) {
                //           //   //     return 'Please enter a correct password';
                //           //   //   }
                //           //   //   return null;
                //           //   // },
                //           //   controller: oPassFieldController,
                //           //   obscureText: true,
                //           //   autofillHints: [AutofillHints.password],
                //           //   keyboardType: TextInputType.visiblePassword,
                //           //   onChanged: (text) {
                //           //     setState(() {
                //           //       validateOPass = false;
                //           //     });
                //           //   },
                //           //   decoration: InputDecoration(
                //           //     errorText: validateOPass ? oPassError : null,
                //           //     hintText: 'Old Password',
                //           //     contentPadding: EdgeInsets.all(15),
                //           //     border: OutlineInputBorder(
                //           //       borderRadius: BorderRadius.circular(0.0),
                //           //     ),
                //           //   ),
                //           // ),
                //           // //Old Password field
                //           //
                //           // SizedBox(
                //           //   height: 20,
                //           // ),
                //           // Center(
                //           //   child: Text(
                //           //     'New information',
                //           //     style: TextStyle(fontSize: 22),
                //           //     textAlign: TextAlign.center,
                //           //   ),
                //           // ),
                //           // SizedBox(
                //           //   height: 10,
                //           // ),
                //           // RichText(
                //           //   text: TextSpan(
                //           //     text: 'New Password',
                //           //     style:
                //           //         TextStyle(fontSize: 16.0, color: Colors.black),
                //           //     children: [
                //           //       TextSpan(
                //           //         text: ' *',
                //           //         style: TextStyle(
                //           //             color: Colors.red, fontSize: 16.0),
                //           //       ),
                //           //     ],
                //           //   ),
                //           // ),
                //           // TextFormField(
                //           //   // The validator receives the text that the user has entered.
                //           //   // validator: (value) {
                //           //   //   if (value == null || value.isEmpty) {
                //           //   //     return 'Please enter a vaild passowrd';
                //           //   //   }
                //           //   //   return null;
                //           //   // },
                //           //   controller: passFieldController,
                //           //   obscureText: true,
                //           //   autofillHints: [AutofillHints.password],
                //           //   keyboardType: TextInputType.visiblePassword,
                //           //   onChanged: (text) {
                //           //     setState(() {
                //           //       validatePass = false;
                //           //     });
                //           //   },
                //           //   decoration: InputDecoration(
                //           //     errorText: validatePass ? passError : null,
                //           //     hintText: 'New Password',
                //           //     contentPadding: EdgeInsets.all(15),
                //           //     border: OutlineInputBorder(
                //           //       borderRadius: BorderRadius.circular(0.0),
                //           //     ),
                //           //   ),
                //           // ),
                //           // // New Password Field
                //           //
                //           // SizedBox(height: 15),
                //           // RichText(
                //           //   text: TextSpan(
                //           //     text: 'Re-Type Password',
                //           //     style:
                //           //         TextStyle(fontSize: 16.0, color: Colors.black),
                //           //     children: [
                //           //       TextSpan(
                //           //         text: ' *',
                //           //         style: TextStyle(
                //           //             color: Colors.red, fontSize: 16.0),
                //           //       ),
                //           //     ],
                //           //   ),
                //           // ),
                //           // TextFormField(
                //           //   // The validator receives the text that the user has entered.
                //           //   // validator: (value) {
                //           //   //   if (value == null || value.isEmpty) {
                //           //   //     return 'Please enter the same passowrd';
                //           //   //   }
                //           //   //   return null;
                //           //   // },
                //           //   controller: rPassFieldController,
                //           //   obscureText: true,
                //           //   autofillHints: [AutofillHints.password],
                //           //   keyboardType: TextInputType.visiblePassword,
                //           //   onChanged: (text) {
                //           //     setState(() {
                //           //       validateRPass = false;
                //           //     });
                //           //   },
                //           //   decoration: InputDecoration(
                //           //     errorText: validateRPass ? rPassError : null,
                //           //     hintText: 'Re-Type Password',
                //           //     contentPadding: EdgeInsets.all(15),
                //           //     border: OutlineInputBorder(
                //           //       borderRadius: BorderRadius.circular(0.0),
                //           //     ),
                //           //   ),
                //           // ),
                //           // Re-Type Password Field
                //         ],
                //       ),
                //       SizedBox(height: 20),
                //       Container(
                //         width: double.infinity,
                //         height: 50,
                //         child: ElevatedButton(
                //           onPressed: () => changePass(),
                //           child: Text(
                //             'Change Password',
                //             style: TextStyle(fontSize: 18),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUser() async{
      await RemoteApi.getUserInfo().then((value) => setState(()=>user));
  }

  Future changePass() async {
    // if (emailFieldController.text.isEmpty) {
    //   emailError = 'Email is required!';
    //   setState(() => validateEmail = true);
    //   return;
    // }

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
        toast('Please enter a new Password');
        return;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    final value = await load('user_id');

    if (value != '-1') {
      sendPostToUpdatePass(value);
    } else {
      toast('User was not found!');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  // Future<void> setProfilePic() async {
  //   String profilePic = await getProfilePic();
  //   profileImage = DecorationImage(
  //     image: NetworkImage(profilePic),
  //   );
  // }

  void sendPostToUpdatePass(String userId) {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/changePass.php'),
        body: {
          'user_id': userId,
          'email': user.userName,
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
}
