import 'dart:convert';
// import 'package:pdf/pdf.dart';
// import 'dart:io';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/DashBoardAdmin.dart';
import 'package:upgrader/upgrader.dart';
// import 'package:smart_select/smart_select.dart';
import 'Choices.dart';
import 'JasonHolders/RemoteApi.dart';
import 'Pages/Client/DashBoard.dart';
import 'Widgets/Functions/random.dart';
import 'Widgets/Others/SizeTransition.dart';
import 'Widgets/ProgressBars/ProgressBar.dart';
// import 'Widgets/Others/TextFieldShadow.dart';
// import 'Pages/Client/DashBoard.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
//
// Future<void> _messageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   notification(message);
// }
//
// void notification(RemoteMessage message) {
//   RemoteNotification notification = message.notification;
//   AndroidNotification android = message.notification?.android;
//   if (notification != null && android != null) {
//     flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channel.description,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             // icon: 'launch_background',
//           ),
//         ));
//   }
// }


final routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  //
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  //
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // Upgrader().clearSavedSettings(); // REMOVE this for release builds
  load('user_type').then(
    (value) => runApp(
      MaterialApp(
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff0065a3, customColors),
        ),
        // home: MyApp(getRoute(value)),
        home: UpgradeAlert(
            // debugLogging: true,
            // debugAlwaysUpgrade: true,
            child:getRoute(value)
        ),
        navigatorObservers: [routeObserver],
      ),
    ),
  );
  client = await RemoteApi.getClientList();
}

Widget getRoute(String str) {
  if (str == "-1") {
    return LoginPage();
  } else if (str.contains("client")) {
    return DashBoard();
  } else if (str.contains("admin")) {
    return DashBoardTest1();
  }
  return LoginPage();
}

// class MyApp extends StatelessWidget {
//   final page;
//
//   MyApp(this.page);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CMS Login UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: page,
//       navigatorObservers: [routeObserver],
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController emailFieldController = new TextEditingController(),
      passFieldController = new TextEditingController();
  bool validateEmail = false, validatePassword = false, loading = false;
  // FirebaseMessaging messaging;

  // @override
  // void initState() {
  //   super.initState();

  // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var iOS = new IOSInitializationSettings();
  // var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  // flutterLocalNotificationsPlugin.initialize(initSetttings,
  //     onSelectNotification: onSelectNotification);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   notification(message);
  // });
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //   print("message recieved");
  //   // showNotification();
  //   print(event.notification.body);
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //   print('Message clicked!');
  // });
  // }

  // ignore: missing_return
  // Future onSelectNotification(String payload) {
  //   debugPrint("payload : $payload");
  //   showDialog(
  //     context: context,
  //     builder: (_) => new AlertDialog(
  //       title: new Text('Notification'),
  //       content: new Text('$payload'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // load('client_id').then((value) {
    //   if (value != '-1') {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => DashBoard()));
    //   }
    // });
    double statusBarHeight = MediaQuery.of(context).padding.top;

    final emailField = Container(
      child: TextField(
        controller: emailFieldController,
        obscureText: false,
        style: style,
        onChanged: (text) {
          setState(() {
            validateEmail = false;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          fillColor: Colors.white,
          filled: true,
          errorText: validateEmail ? 'Username is required' : null,
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
    final passwordField = Container(
      child: TextField(
        controller: passFieldController,
        obscureText: true,
        style: style,
        onChanged: (text) {
          setState(() {
            validatePassword = false;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          fillColor: Colors.white,
          filled: true,
          errorText: validatePassword ? 'Password is required' : null,
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      ),
    ); // Password Text Field
    final loginButton = Material(
      elevation: 5.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff0065a3).withOpacity(0.77),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(
          Radius.circular(30.0),
        )),
        height: 50,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () => checkInfo(),
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ); //Login Button
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/gmbar4.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Align(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // children: [
              //   Expanded(child: Container(
              //     // decoration: BoxDecoration(
              //     //   image: DecorationImage(
              //     //       image: AssetImage("assets/image/gmbar4.png"),
              //     //       fit: BoxFit.cover),
              //     // ),
              //
              //   )),
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                // color: Colors.white.withOpacity(0.5),
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //       image: AssetImage("assets/image/bottom.png"),
                //       fit: BoxFit.cover),
                // ),
                // child: Column(children: [

                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/1.png",
                          fit: BoxFit.contain,
                        ),
                      ), // Image setting
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/2.png",
                          fit: BoxFit.contain,
                        ), // Image setting
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/3.png",
                          fit: BoxFit.contain,
                        ), // Image setting
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/4.png",
                          fit: BoxFit.contain,
                        ), // Image setting
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/5.png",
                          fit: BoxFit.contain,
                        ), // Image setting
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/image/6.png",
                          fit: BoxFit.contain,
                        ), // Image setting
                      ),
                    ),
                  ],
                ),
                // ),
                // Container(
                //   height: 50,
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: Container(), // Image setting
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Image.asset(
                //           "assets/image/5.png",
                //           fit: BoxFit.contain,
                //         ), // Image setting
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Image.asset(
                //           "assets/image/6.png",
                //           fit: BoxFit.contain,
                //         ), // Image setting
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Container(), // Image setting
                //       ),
                //     ],
                //   ),
                // ),
                // ],),
              ),
              // ],
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Stack(
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(0, 2))
                                  ],
                                  color: Color(0xff0065a3).withOpacity(0.77),
                                ),
                                width: width - 100,
                                child: Image.asset(
                                  "assets/image/logonoback.png",
                                  fit: BoxFit.contain,
                                ), // Image setting
                              ),
                              SizedBox(height: 5.0),
                              SizedBox(
                                width: width - 100,
                                child: AutoSizeText(
                                  'Smart Solar Aviation Obstruction Light',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 1000),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              SizedBox(
                                width: width - 140,
                                child: AutoSizeText(
                                  'Centralized Management System',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,fontSize: 1000),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              emailField,
                              SizedBox(height: 15.0),
                              passwordField,
                              SizedBox(height: 30.0),
                              loginButton,
                            ],
                          ),
                        ), // Setting for Text Field, Password Field and Login Button
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkInfo() async {
    if (emailFieldController.text.isEmpty) {
      setState(() {
        validateEmail = true;
      });
      return;
    }

    if (passFieldController.text.isEmpty) {
      setState(() {
        validatePassword = true;
      });
      return;
    }
    setState(() => loading = true);

    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/login.php'),
        body: {
          'email': emailFieldController.text,
          'password': passFieldController.text
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map["res"] == "0") {
          String userType;
          var route;
          // toast(map["type"].toString());
          if (map["type"].toString().compareTo('3') != 0) {
            // FirebaseMessaging.instance.getToken().then((value) {
            //   http.post(
            //       Uri.parse(
            //           'http://103.18.247.174:8080/AmitProject/saveToken.php'),
            //       body: {
            //         'client_id': result[0],
            //         'token': value,
            //       }).then((response) {
            //     String res = json.decode(response.body);
            //     if (res.contains("200")) {
            //       save('token', value);
            userType = "admin";
            route = DashBoardTest1();

            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => DashBoardTest1()));
            // print(">>>:"+value+":<<<");
            // toast('Logged in successfully');
            // setState(() => loading = false);
            //     } else {
            //       toast(res);
            //       setState(() => loading = false);
            //     }
            //   }).onError((error, stackTrace) {
            //     toast('Error: ' + error.message);
            //     setState(() => loading = false);
            //   });
            // }).onError((error, stackTrace) {
            //   toast('Error getting notification token');
            //   setState(() => loading = false);
            // });
          } else {
            userType = "client";
            route = DashBoard();
            // print(">>>:"+value+":<<<");
          }

          save('user_type', userType);
          save('profile_pic', '-1');
          save('client_id', map["clientId"].toString());
          save('user_id', map["userId"].toString());
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => route));
          toast('Logged in successfully');
          setState(() => loading = false);
        } else {
          toast('Email or password is incorrect');
          setState(() => loading = false);
        }
      } else {
        toast(getResponseError(response));
        setState(() => loading = false);
      }
    }).onError((error, stackTrace) {
      toast('Error: ' + error.message);
      print(error);
      setState(() => loading = false);
    });
  }

  String getResponseError(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        return (response.body.toString());
      case 401:
        return (response.body.toString());
      case 403:
        return (response.body.toString());
      case 500:
      default:
        return 'Error occurred while Communication with Server with StatusCode: ${response.statusCode}';
    }
  }
}

void logOut(BuildContext context) {
  // load('token').then((value) {
  //   http.post(
  //       Uri.parse('http://103.18.247.174:8080/AmitProject/deleteToken.php'),
  //       body: {
  //         'token': value,
  //       }).then((response) {
  //     String res = json.decode(response.body);
  //     if (res == "200") {
  //       save('token', '-1');
  save('user_type', '-1');
  save('profile_pic', '-1');
  save('client_id', '-1');
  save('user_id', '-1');
  Navigator.pushReplacement(context, SizeRoute(page: LoginPage()));
  // } else {
  //   toast("Error logging out!");
  // }
  //   }).onError((error, stackTrace) {
  //     toast('Error: ' + error.message);
  //   });
  // });
}
