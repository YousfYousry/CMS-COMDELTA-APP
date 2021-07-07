import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:login_cms_comdelta/DeviceStatus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import '../Widgets/DashBoardHeader.dart';
import '../Widgets/SizeTransition.dart';
import '../Widgets/Admin/SideDrawerAdmin.dart';
import '../Widgets/CustomeAppBar.dart';
import '../GoogleMap.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class DashBoard extends StatefulWidget {

  DashBoard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoard> {
  void notification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              // icon: 'launch_background',
            ),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notification(message);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/background.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          child: CustomeAppBar('Dashboard'),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawerAdmin(), // sidebar
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),

              DashBoardHeader(),

              Text(
                'Satellite Management System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(context, SizeRoute(page: DeviceStatus()));
                },
                child: Container(
                  width: 320,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 60,
                          height: 110,
                          child: Image.asset('assets/image/statusb.png')),
                      Container(
                        width: 200,
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Device Status',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text.rich(TextSpan(
                                text: 'Signal of the Devices',
                                style: TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ), //Container for Device Status

              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    SizeRoute(
                      page: GoogleMapApp(),
                    ),
                  );
                },
                child: Container(
                  width: 320,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 110,
                        child: Image.asset('assets/image/mapsb.png'),
                      ),
                      Container(
                        width: 200,
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Map',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Location of the Devices',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ), //Container for Map
            ],
          ), // Column for DasbBoard Cards
        ),
      ),
    );
  }
}
