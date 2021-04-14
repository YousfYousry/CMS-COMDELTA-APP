import 'package:flutter/material.dart';
import '../ForgotPasswordPage.dart';
import '../UserProfilePage.dart';
import './SizeTransition.dart';
import '../FeedBackPage.dart';
import '../DashBoard.dart';
import '../main.dart';

class SideDrawer extends StatelessWidget {
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
                      child: Image.asset(
                        'assets/image/Avatar.jpeg',
                        height: 80.0,
                        width: 80.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("EDOTCO COMDELTA"),
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashoard'),
            onTap: () => {
              Navigator.push(
                context,
                SizeRoute(
                  page: DashBoardPage(),
                ),
              ),
            },
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
          Divider(
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
            title: Text("Change Passowrd"),
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

  void logOut(BuildContext context) {
    save('client_id', '-1');
    save('user_id', '-1');
    Navigator.pushReplacement(context, SizeRoute(page: MyHomePage()));
  }
}
