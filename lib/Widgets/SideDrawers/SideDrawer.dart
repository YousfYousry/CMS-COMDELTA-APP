// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/JasonHolders/UserInfoJason.dart';
import 'package:login_cms_comdelta/Pages/Client/ActiveDeviceCard.dart';
import 'package:login_cms_comdelta/Pages/Client/DeviceHistory.dart';

// import 'package:login_cms_comdelta/Pages/Client/DashBoard.dart';
import 'package:login_cms_comdelta/Pages/Client/InactiveDeviceCard.dart';
import 'package:login_cms_comdelta/Pages/Client/TotalDevicesCard.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../public.dart';
import '../../Pages/ForgotPasswordPage.dart';
import '../../Pages/UserProfilePage.dart';
import '../../main.dart';
import '../Others/SizeTransition.dart';
import '../../Pages/Client/FeedBackPage.dart';

class SideDrawer extends StatefulWidget {
  final setOpen;

  SideDrawer({this.setOpen});

  @override
  _SideDrawer createState() => _SideDrawer();
}

class _SideDrawer extends State<SideDrawer> {
  // var profilePic =
  //     'http://cmscomdelta.com/assets/dist/img/profile_picture/92a2fb1a7d6a2342b1ccca2b6e5d740d.png';
  // var name = '';
  bool device = false;

  Widget itemChild(var title, var route) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 72),
        height: 30,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
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
    widget.setOpen(true);
    // getInfo();
    super.initState();
  }

  @override
  void dispose() {
    widget.setOpen(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff0065a3),
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstOut),
              //   image: AssetImage('assets/image/background.jpg'),
              // ),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,color: Colors.white.withOpacity(0.8)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: user.logo,
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
                  Text(user.firsName + ' ' + user.lastName,style: TextStyle(color: Colors.white),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: user.status.trim() == "1"
                            ? Colors.green
                            : Colors.red,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        user.status.trim() == "1" ? "Online" : "Offline",
                        style: TextStyle(
                          color: user.status.trim() == "1"
                              ? Colors.green
                              : Colors.red,
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
              onTap: () => Navigator.pop(context)
              // {
              // Navigator.push(
              //   context,
              //   SizeRoute(
              //     page: DashBoard(),
              //   ),
              // ),
              // }
              // ,
              ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.push(
                context,
                SizeRoute(
                  page: FeedBackPage(),
                ),
              ),
            },
          ),
          ExpansionPanelList(
            elevation: 0,
            animationDuration: Duration(milliseconds: 500),
            expandedHeaderPadding: EdgeInsets.all(0),
            dividerColor: Color(0xfffafafa),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                device = !isExpanded;
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
                        device = !isExpanded;
                      });
                    },
                  );
                },
                body: Column(
                  children: [
                    itemChild("All Devices", TotalDeviceCard()),
                    itemChild("Active Devices", ActiveDeviceCard()),
                    itemChild("Inactive Devices", InactiveDeviceCard()),
                    itemChild("Device History", DeviceHistoryClient()),
                  ],
                ),
                isExpanded: device,
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
              ).then((value) => setState(() => user)),
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

// Future<void> getInfo() async {
//   setState(() {
//     name = user.firsName + ' ' + user.lastName;
//     profilePic = user.logo;
//   });
// }

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
//             name = result[0] + ' ' + result[1];
//             if (result[3].isNotEmpty) {
//               setState(() => profilePic = result[3]);
//               save('profile_pic', result[3]);
//             }
//           });
//         } else {
//           toast('Something wrong with the server!');
//         }
//       } else {
//         toast('User does not exist');
//       }
//     } else {
//       throw Exception("Unable to get devices list");
//     }
//   }).onError((error, stackTrace) {
//     toast('Error: ' + error.message);
//   });
// }
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
