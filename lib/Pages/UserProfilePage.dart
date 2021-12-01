import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_cms_comdelta/public.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';
// import 'package:login_cms_comdelta/JasonHolders/UserInfoJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
// import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'dart:convert';
import 'dart:io';

import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController firstName = new TextEditingController(),
      lastName = new TextEditingController(),
      email = new TextEditingController();
  // var fullName = '';

  // bool loading = true;
  // var profileImage = user.logo;
  final snackBar = SnackBar(
    content: Text('Updating Profile'),
    duration: Duration(seconds: 10),
  );

  @override
  void initState() {
    getInfo();
    getUser();
    super.initState();
  }
  String base64Image = '';

  chooseImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File file = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );
      setState(() {
        user.setLogo(FileImage(file));
      });
      base64Image = base64Encode(file.readAsBytesSync());
    }
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
          child: CustomAppBarBack(context, 'User Profile'),
          preferredSize: const Size.fromHeight(50),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: PrimaryColor,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: user.userName.isEmpty ? null : updateProfile,
        ),
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
                        width: 110,
                        height: 110,
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                image:DecorationImage(
                                  image:  user.logo,
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: CircleBorder(),
                                  onTap: () => chooseImage(),
                                  child: Container(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.all(2),
                                // padding: EdgeInsets.all(4),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: PrimaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: CircleBorder(),
                                    onTap: () => chooseImage(),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      Text(
                        user.fulName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SmartField(
                  title: "First Name",
                  controller: firstName,
                  filled: false,
                  opacity: 0.5,
                ),
                SmartField(
                  title: "Last Name",
                  controller: lastName,
                  filled: false,
                  opacity: 0.5,
                ),
                SmartField(
                  title: "Email",
                  controller: email,
                  filled: false,
                  opacity: 0.5,
                ),
                SizedBox(
                  height: 60,
                ),

                // Divider(
                //   thickness: 2,
                // ),
                // Container(
                //   width: 330,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       RichText(
                //         text: TextSpan(
                //           text: 'First Name',
                //           style:
                //               TextStyle(fontSize: 16.0, color: Colors.black),
                //           children: [
                //             TextSpan(
                //               text: ' *',
                //               style: TextStyle(
                //                   color: Colors.red, fontSize: 16.0),
                //             ),
                //           ],
                //         ),
                //       ),
                //       TextField(
                //         // The validator receives the text that the user has entered.
                //         autofillHints: [AutofillHints.name],
                //         keyboardType: TextInputType.text,
                //         controller: firstName,
                //         decoration: InputDecoration(
                //           hintText: 'First Name',
                //           contentPadding: EdgeInsets.all(15),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(0.0),
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 8),
                //       RichText(
                //         text: TextSpan(
                //           text: 'Last Name',
                //           style:
                //               TextStyle(fontSize: 16.0, color: Colors.black),
                //           children: [
                //             TextSpan(
                //               text: ' *',
                //               style: TextStyle(
                //                   color: Colors.red, fontSize: 16.0),
                //             ),
                //           ],
                //         ),
                //       ),
                //       TextField(
                //         // The validator receives the text that the user has entered.
                //         autofillHints: [AutofillHints.name],
                //         keyboardType: TextInputType.text,
                //         controller: lastName,
                //         decoration: InputDecoration(
                //           hintText: 'Last Name',
                //           contentPadding: EdgeInsets.all(15),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(0.0),
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 8),
                //       RichText(
                //         text: TextSpan(
                //           text: 'Email',
                //           style:
                //               TextStyle(fontSize: 16.0, color: Colors.black),
                //           children: [
                //             TextSpan(
                //               text: ' *',
                //               style: TextStyle(
                //                   color: Colors.red, fontSize: 16.0),
                //             ),
                //           ],
                //         ),
                //       ),
                //       TextField(
                //         // The validator receives the text that the user has entered.
                //         autofillHints: [AutofillHints.email],
                //         keyboardType: TextInputType.emailAddress,
                //         controller: email,
                //         decoration: InputDecoration(
                //           hintText: 'Email',
                //           contentPadding: EdgeInsets.all(15),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(0.0),
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 12),
                //       Container(
                //         width: double.infinity,
                //         height: 50,
                //         child: ElevatedButton(
                //           onPressed: loading ? null : updateProfile,
                //           child: Text(
                //             'Update Profile',
                //             style: TextStyle(fontSize: 18),
                //           ),
                //         ),
                //         // Add TextFormFields and ElevatedButton here.
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //     width: double.infinity,
        //     height: 50,
        //     child: ElevatedButton(
        //       onPressed: loading ? null : updateProfile,
        //       child: Text(
        //         'Update Profile',
        //         style: TextStyle(fontSize: 18),
        //       ),
        //     ),
        //     // Add TextFormFields and ElevatedButton here.
        //   ),
        // ),
        // Loading(
        //   loading: loading,
        // ),
      ),
    );
  }

  Future<void> getInfo() async {
    setState(() {
      firstName.text = user.firsName;
      lastName.text = user.lastName;
      email.text = user.userName;
    });
  }

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
  //             firstName.text = result[0];
  //             lastName.text = result[1];
  //             fullName = firstName.text + ' ' + lastName.text;
  //             email.text = result[2];
  //             if (result[3].isNotEmpty) {
  //               profileImage = DecorationImage(
  //                 image: NetworkImage(result[3]),
  //               );
  //             }
  //           });
  //         } else {
  //           toast('Something wrong with the server!');
  //         }
  //       } else {
  //         toast('User does not exist');
  //       }
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

  Future<void> updateProfile() async {
    // toast('Updating Profile');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    load('user_id').then((value) =>
        value != '-1' ? sendPostToUpdate(value) : toast('User was not found!'));
  }

  Future<void> sendPostToUpdate(String userId) async{
    try {
      if (base64Image.isNotEmpty) {
        final picRes = await http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/uploadPic.php'), body: {
          "image": base64Image,
          "name": userId,
        });
        if(picRes.statusCode!=200){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          toast(getResponseError(picRes));
          return;
        }
      }


      final response = await http.post(
          Uri.parse(
              'http://103.18.247.174:8080/AmitProject/updateUserProfile.php'),
          body: {
            'user_id': userId,
            'first_name': firstName.text,
            'last_name': lastName.text,
            'email': email.text,
          });
        if (response.statusCode == 200) {
          if (json.decode(response.body) == '0') {
            setState(() {
              toast('Profile has been updated successfully');
              getUser();
            });
          } else {
            toast('Something wrong with the server!');
          }
        } else {
          toast(getResponseError(response));
        }
    }catch(error){
      toast(error.toString());
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future<void> getUser() async{
    await RemoteApi.getUserInfo().then((value) => setState(()=>user));
    getInfo();
  }
}
