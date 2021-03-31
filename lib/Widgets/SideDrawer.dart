import 'package:flutter/material.dart';
import '../main.dart';
import '../DashBoard.dart';

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
                        border: Border.all(width: 4),
                        borderRadius: BorderRadius.circular(50.0)),
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
                MaterialPageRoute(
                  builder: (context) => DashBoard(),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {},
          ),
          Divider(
            color: Colors.red,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Setting",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_drop_down)
          ]),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("User Profile"),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text("Change Passowrd"),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
