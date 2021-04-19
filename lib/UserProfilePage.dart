import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/Widgets/BottomRight.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/ProgressBar.dart';
import 'dart:convert';
import 'dart:io';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController firstName = new TextEditingController(),
      lastName = new TextEditingController(),
      email = new TextEditingController();
  var title = '';
  bool loading = true;
  var img = DecorationImage(
    image: NetworkImage(
        'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png'),
  );
  final snackBar = SnackBar(
    content: Text('Updating Profile'),
    duration: Duration(seconds: 10),
  );

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  static final String uploadEndPoint = 'http://103.18.247.174:8080/AmitProject/uploadPic.php';
  String status = '';
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
        img = DecorationImage(
          image: FileImage(file),
        );
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
        appBar: PreferredSize(
          child: CustomeAppBar('User Profile'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                height: 610,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO9PbsbTpb9HLsQKEUSnEM5bA5hFiR5rmekw&usqp=CAU'),
                        ),
                      ),
                      width: 340,
                      height: 180,
                      child: Container(
                        height: 100,
                        alignment: Alignment(0.0, 1.6),
                        child: InkWell(
                          onTap: () {
                            chooseImage();
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: img,
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                bottomRight(
                                  ClipOval(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                      width: 22,
                                      height: 22,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      width: 330,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'First Name',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            // The validator receives the text that the user has entered.
                            autofillHints: [AutofillHints.name],
                            keyboardType: TextInputType.text,
                            controller: firstName,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              text: 'Last Name',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            // The validator receives the text that the user has entered.
                            autofillHints: [AutofillHints.name],
                            keyboardType: TextInputType.text,
                            controller: lastName,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              text: 'Email',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            // The validator receives the text that the user has entered.
                            autofillHints: [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: loading ? null : updateProfile,
                              child: Text(
                                'Update Profile',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            // Add TextFormFields and ElevatedButton here.
                          ),
                        ],
                      ),
                    ),
                  ],
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
              firstName.text = result[0];
              lastName.text = result[1];
              title = firstName.text + ' ' + lastName.text;
              email.text = result[2];
              if (result[3].isNotEmpty) {
                img = DecorationImage(
                  image: NetworkImage(result[3]),
                );
              }
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
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  Future<void> updateProfile() async {
    // toast('Updating Profile');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    load('user_id').then((value) =>
        value != '-1' ? sendPostToUpdate(value) : toast('User was not found!'));
  }

  void sendPostToUpdate(String userId) {
    if (base64Image.isNotEmpty) {
      http.post(Uri.parse(uploadEndPoint), body: {
        "image": base64Image,
        "name": userId,
      }).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
    }
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/updateUserProfile.php'),
        body: {
          'user_id': userId,
          'first_name': firstName.text,
          'last_name': lastName.text,
          'email': email.text,
        }).then((response) {
      if (response.statusCode == 200) {
        if (json.decode(response.body) == '0') {
          setState(() {
            toast('Profile has been updated successfully');
            title = firstName.text + ' ' + lastName.text;
          });
        } else {
          toast('Something wrong with the server!');
        }
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else {
        toast('Something wrong with the server!');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // throw Exception("Unable to Update Profile");
      }
    }).onError((error, stackTrace) {
      toast('Error: ' + error.message);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}

Future<String> load(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '-1';
}
