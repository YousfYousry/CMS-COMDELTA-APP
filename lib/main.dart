import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/Classes/Notification.dart';
import 'package:login_cms_comdelta/Pages/Admin/AdminDashBoard.dart';
import 'package:login_cms_comdelta/Pages/Client/ClientDashBoard.dart';
import 'package:upgrader/upgrader.dart';

import 'JasonHolders/RemoteApi.dart';
import 'Widgets/ProgressBars/Loading.dart';
import 'Widgets/Others/SizeTransition.dart';
import 'public.dart';

Future<void> init() async {
  await Firebase.initializeApp();
  await initPlatformState();
  await RemoteApi.getUserInfo();
  location = await RemoteApi.getLocationList();
  client = await RemoteApi.getClientList();
  await NotificationService().init();
  FirebaseMessaging.onMessage.listen(_messageHandler);

  int width = (MediaQuery.of(NavigationService.navigatorKey.currentContext).size.width * MediaQuery.of(NavigationService.navigatorKey.currentContext).devicePixelRatio)~/ 24.0;
  greenIcon = await getBytesFromAsset('assets/image/green_marker.png', width);
  yellowIcon = await getBytesFromAsset('assets/image/yellow_marker.png', width);
  redIcon = await getBytesFromAsset('assets/image/red_marker.png', width);

  //this part happens only when user is logged in
  if (!isLogged()) {
    return;
  }
  final clientId = await load('client_id');
  if (clientId == '-1') {
    return;
  }
  if (userType == clientKeyWord) {
    devices = await RemoteApi.getClientDevicesList(clientId);
  } else {
    devices = await RemoteApi.getDevicesList();
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        "high_important_channel", "high important notification",
        channelDescription: "this channel is used for important notifications.",
        importance: Importance.max,
        priority: Priority.max);
const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(
  presentAlert: true,
  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  presentBadge: true,
  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  presentSound:
      true,
      // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  // sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
  // badgeNumber: int?, // The application's icon badge number
  // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
  // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
  // threadIdentifier: String? (only from iOS 10 onwards)
);
const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
    macOS: null);

Future<void> _messageHandler(RemoteMessage message) async {
  // toast(message.notification.title);
  await flutterLocalNotificationsPlugin.show(12345, message.notification.title,
      message.notification.body, platformChannelSpecifics,
      payload: 'data');
}

// bool pressed = false;
Future selectNotification(String payload) async {
  // save('notification', 'open');
  // route();
  // if (publicContext != null) {
  //   Navigator.of(publicContext).pushReplacementNamed('/second');
  // Navigator.of(publicContext).pushNamed('/second');
  // }
  // initialRoute = '/second';
  // openHis = true;
  if (dashBoardContext != null && devices.isNotEmpty) {
    Navigator.push(
      dashBoardContext,
      SizeRoute(
        page: historyPage,
      ),
    );
  }
}

// BuildContext publicContext;
final routeObserver = RouteObserver<PageRoute>();
// String initialRoute = '/';
// var page;

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() => _LoadingPage();
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class _LoadingPage extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    try {
      init().whenComplete(() => Navigator.pushReplacement(
          context,
          SizeRoute(
            page: getRoute(),
          )));
    } catch (error) {
      toast(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/loading_page.gif"),
            fit: BoxFit.cover),
      ),
      // child: Loading(
      //   loading: false,
      //   color: Colors.white,
      // ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  userType = await load('user_type');

  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xff0065a3, customColors),
      ),
      home: UpgradeAlert(child: (isLogged()) ? LoadingPage() : LoginPage()), //
      navigatorObservers: [routeObserver],
      navigatorKey: NavigationService.navigatorKey, // set property
    ),
  );

  // if (initialRoute.isEmpty) {
  //   initialRoute = '/';
  // }
  // final NotificationAppLaunchDetails notificationAppLaunchDetails = !kIsWeb &&
  //     Platform.isLinux
  //     ? null
  //     : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // String initialRoute = HomePage.routeName;
  // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //   selectedNotificationPayload = notificationAppLaunchDetails.payload;
  //   initialRoute = SecondPage.routeName;
  // }
  // NotificationSettings settings =
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
}

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

Future<void> initPlatformState() async {
  try {
    if (Platform.isAndroid) {
      _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } on PlatformException {}
}

void _readAndroidBuildData(AndroidDeviceInfo build) {
  deviceIdentifier = build.androidId.toLowerCase();
  model = build.manufacturer + ": " + build.model;
  // return <String, dynamic>{
  //   'version.securityPatch': build.version.securityPatch,
  //   'version.sdkInt': build.version.sdkInt,
  //   'version.release': build.version.release,
  //   'version.previewSdkInt': build.version.previewSdkInt,
  //   'version.incremental': build.version.incremental,
  //   'version.codename': build.version.codename,
  //   'version.baseOS': build.version.baseOS,
  //   'board': build.board,
  //   'bootloader': build.bootloader,
  //   'brand': build.brand,
  //   'device': build.device,
  //   'display': build.display,
  //   'fingerprint': build.fingerprint,
  //   'hardware': build.hardware,
  //   'host': build.host,
  //   'id': build.id,
  //   'manufacturer': build.manufacturer,
  //   'model': build.model,
  //   'product': build.product,
  //   'supported32BitAbis': build.supported32BitAbis,
  //   'supported64BitAbis': build.supported64BitAbis,
  //   'supportedAbis': build.supportedAbis,
  //   'tags': build.tags,
  //   'type': build.type,
  //   'isPhysicalDevice': build.isPhysicalDevice,
  //   'androidId': build.androidId,
  //   'systemFeatures': build.systemFeatures,
  // };
}

void _readIosDeviceInfo(IosDeviceInfo data) {
  deviceIdentifier = data.identifierForVendor.toLowerCase();
  model = data.localizedModel;
  // return <String, dynamic>{
  //   'name': data.name,
  //   'systemName': data.systemName,
  //   'systemVersion': data.systemVersion,
  //   'model': data.model,
  //   'localizedModel': data.localizedModel,
  //   'identifierForVendor': data.identifierForVendor,
  //   'isPhysicalDevice': data.isPhysicalDevice,
  //   'utsname.sysname:': data.utsname.sysname,
  //   'utsname.nodename:': data.utsname.nodename,
  //   'utsname.release:': data.utsname.release,
  //   'utsname.version:': data.utsname.version,
  //   'utsname.machine:': data.utsname.machine,
  // };
}

Widget getRoute() {
  if (userType.contains(clientKeyWord)) {
    return ClientDashBoard();
  } else if (userType.contains(adminKeyWord)) {
    return DashBoardTest1();
  }
  return LoginPage();
}

bool isLogged() {
  if (userType.contains(clientKeyWord)) {
    return true;
  } else if (userType.contains(adminKeyWord)) {
    return true;
  }
  return false;
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

  @override
  void initState() {
    super.initState();

    try {
      init();
    } catch (error) {
      toast(error);
    }

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
  }

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
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 80),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 1000),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              SizedBox(
                                width: width - 140,
                                child: AutoSizeText(
                                  'Centralized Management System',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 1000),
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
                    Loading(
                      loading: loading,
                    ),
                    // Center(
                    //   child: Visibility(
                    //     child: CircularProgressIndicatorApp(),
                    //     visible: loading,
                    //   ),
                    // ),
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

    try {
      final response = await http.post(
          Uri.parse('http://103.18.247.174:8080/AmitProject/login.php'),
          body: {
            'email': emailFieldController.text.trim(),
            'password': passFieldController.text.trim()
          }).onError((error, stackTrace) {
        toast('Error: ' + error.message);
        setState(() => loading = false);
        return;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map["res"] == "0") {
          var route;
          if (map["type"].toString().isEmpty ||
              map["clientId"].toString().isEmpty ||
              deviceIdentifier.isEmpty ||
              !await setNotificationToken(
                  map["type"].toString(), map["clientId"].toString())) {
            if (deviceIdentifier.isEmpty) {
              toast("Device Identifier is unknown");
            }
            if (map["clientId"].toString().isEmpty) {
              toast("Client Id is unknown");
            }
            if (map["type"].toString().isEmpty) {
              toast("User Type is unknown");
            }
            setState(() => loading = false);
            return;
          }

          if (map["type"].toString().compareTo('3') != 0) {
            userType = adminKeyWord;
            route = DashBoardTest1();
            try {
              devices = await RemoteApi.getDevicesList();
            }catch(error){}
          } else {
            userType = clientKeyWord;
            route = ClientDashBoard();
            try {
              devices = await RemoteApi.getClientDevicesList(
                  map["clientId"].toString());
            }catch(error){}
          }

          save('user_type', userType);
          save('profile_pic', '-1');
          save('client_id', map["clientId"].toString());
          await save('user_id', map["userId"].toString())
              .then((value) => RemoteApi.getUserInfo());
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => route));
          toast('Logged in successfully');
        } else {
          toast('Email or password is incorrect!');
          print(response.body);
        }
      } else {
        toast(getResponseError(response));
      }
    } catch (error) {
      toast(error.toString());
    }
    setState(() => loading = false);
  }

  Future<bool> setNotificationToken(String type, String clientId) async {
    if (type.trim() == "3") {
      if (!(clientId.trim() == "5" || clientId.trim() == "8")) {
        return true;
      }
    }

    final token = await FirebaseMessaging.instance.getToken();
    final response = await http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/admin/setToken.php'),
        body: {
          'identifier': deviceIdentifier,
          'model': model,
          'token': token,
          'type': type,
          'client_id': clientId,
        });

    if (json.decode(response.body).contains("200")) {
      await save('token', token);
      return true;
    } else {
      toast("Failed to set notification token");
      return false;
    }
  }
}

Future<void> logOut(BuildContext context) async {
  devices.clear();
  final response = await http.post(
      Uri.parse('http://103.18.247.174:8080/AmitProject/admin/deleteToken.php'),
      body: {
        'identifier': deviceIdentifier,
      }).onError((error, stackTrace) {
    toast('Error: ' + error.message);
    return;
  });
  String res = json.decode(response.body);
  if (res == "200" || res == "100") {
    // if (res == "100") toast("Your notification token is not registered!");
    save('token', '-1');
    save('user_type', '-1');
    save('profile_pic', '-1');
    save('client_id', '-1');
    save('user_id', '-1');
    Navigator.pushReplacement(context, SizeRoute(page: LoginPage()));
  } else {
    toast("Error deleting token!");
  }
}
