import 'dart:convert';

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/DashBoardAdmin.dart';
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
  load('user_type').then(
    (value) => runApp(
      MaterialApp(
        // home: MyApp(getRoute(value)),
        home: getRoute(value),
        navigatorObservers: [routeObserver],
      ),
    ),
  );
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
      height: 50.0,
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
          fillColor: Colors.white,
          filled: true,
          errorText: validateEmail ? 'Username is required' : null,
          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
    final passwordField = Container(
      height: 50.0,
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
          fillColor: Colors.white,
          filled: true,
          errorText: validatePassword ? 'Password is required' : null,
          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
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
              image: AssetImage("assets/image/backgroundlogin3.png"),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                          Text(
                            'Login Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          // SizedBox(height: 20.0),
                          // Text('Welcome to Comdelta Tracking System',
                          //     style:
                          //         TextStyle(fontSize: 16, color: Colors.white)),
                          SizedBox(height: 30.0),
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
