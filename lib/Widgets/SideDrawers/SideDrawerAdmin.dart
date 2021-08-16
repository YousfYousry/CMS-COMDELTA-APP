import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditClient.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Pages/Admin/ManageClients.dart';
import 'package:login_cms_comdelta/Pages/Admin/ManageDevices.dart';
import 'package:login_cms_comdelta/Pages/Admin/FailedDevices.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Position/MiddleLeft.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/ForgotPasswordPage.dart';
import '../../Pages/UserProfilePage.dart';
import '../Others/SizeTransition.dart';
import '../../main.dart';

class SideDrawerAdmin extends StatefulWidget {
  @override
  _SideDrawer createState() => _SideDrawer();
}

class _SideDrawer extends State<SideDrawerAdmin> {
  var profilePic =
      'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png';
  var name = '';
  bool button1 = false, button2 = false;

  Widget itemChild(var title, var route) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 72),
        height: 30,
        child: MiddleLeft(
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Color(0xff5e5e5e)),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          SizeRoute(
            page: route,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff0065a3),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profilePic),
                          ),
                        ),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_pin_circle,
                        color: Colors.green,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashoard'),
            onTap: () => Navigator.pop(context),
          ),
          ExpansionPanelList(
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.all(0),
            animationDuration: Duration(milliseconds: 500),
            dividerColor: Color(0xfffafafa),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                button1 = !isExpanded;
                button2 = false;
              });
            },
            children: [
              ExpansionPanel(
                backgroundColor: Color(0xfffafafa),
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Client'),
                    onTap: () {
                      setState(() {
                        button1 = !isExpanded;
                        button2 = false;
                      });
                    },
                  );
                },
                body: Column(
                  children: [
                    itemChild("Manage Client", ManageClient()),
                    itemChild("Add Client", AddClient()),
                  ],
                ),
                isExpanded: button1,
              ),
            ],
          ),

          ExpansionPanelList(
            elevation: 0,
            animationDuration: Duration(milliseconds: 500),
            expandedHeaderPadding: EdgeInsets.all(0),
            dividerColor: Color(0xfffafafa),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                button2 = !isExpanded;
                button1 = false;
              });
            },
            children: [
              ExpansionPanel(
                backgroundColor: Color(0xfffafafa),
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: Icon(Icons.ad_units_sharp),
                    title: Text('Device'),
                    onTap: () {
                      setState(() {
                        button2 = !isExpanded;
                        button1 = false;
                      });
                    },
                  );
                },
                body: Column(
                  children: [
                    itemChild("Manage Device", ManageDevice()),
                    itemChild("Add Device", AddDevice("Add Device", null)),
                    itemChild("Failed Device", FailedDevice()),
                  ],
                ),
                isExpanded: button2,
              ),
            ],
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 16,
                    color: Colors.black38,
                  ),
                ),
              ),
              // Icon(Icons.arrow_drop_down)
            ],
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("User Profile"),
            onTap: () => {
              Navigator.push(
                context,
                SizeRoute(
                  page: UserProfile(),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text("Change Password"),
            onTap: () => {
              Navigator.push(
                context,
                SizeRoute(
                  page: ForgotPassword(),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => logOut(context),
          ),
        ],
      ),
    );
  }

  Future<void> getInfo() async {
    load('user_id').then((value) =>
        value != '-1' ? sendPost(value) : toast('User was not found!'));
    load('profile_pic').then((value) => value.isNotEmpty && value != '-1'
        ? setState(() => profilePic = value)
        : setState(() => profilePic =
            'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png'));
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
              name = result[0] + ' ' + result[1];
              if (result[3].isNotEmpty) {
                setState(() => profilePic = result[3]);
                save('profile_pic', result[3]);
              }
            });
          } else {
            toast('Something wrong with the server!');
          }
        } else {
          toast('User does not exist');
        }
      } else {
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      toast('Error: ' + error.message);
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
