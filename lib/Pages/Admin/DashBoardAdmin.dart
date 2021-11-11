import 'dart:async';

// import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:countup/countup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_spinbox/flutter_spinbox.dart';
// import 'package:http/http.dart' as http;
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:intl/intl.dart';
// import 'package:login_cms_comdelta/Choices.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/JasonHolders/RemoteApi.dart';

// import 'package:login_cms_comdelta/Pages/Admin/DeviceHistory.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/NewDashBoard.dart';

// import 'package:login_cms_comdelta/Widgets/Functions/NewUpdateChecker.dart';
import 'package:login_cms_comdelta/Widgets/Functions/WidgetSize.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/AdvancedSearch.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';

// import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawers/SideDrawerAdmin.dart';

// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
// import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../Choices.dart';
import 'DeviceHistory.dart';

const PrimaryColor = const Color(0xff0065a3);

// final elem = [
//   // 'Total Devices',
//   // 'Active Device Last 1 Hour',
//   'Active Device Last 72 Hour',
//   'Inactive Device Last 72 Hours'
// ];
double width, height;
var dashBoardContext;

class DashBoardTest1 extends StatefulWidget {
  DashBoardTest1({Key key, this.title}) : super(key: key);
  final titles = ['Devices', 'Active', 'Inactive', 'Maps'];
  final icons = [
    CupertinoIcons.device_phone_portrait,
    CupertinoIcons.antenna_radiowaves_left_right, //lock//lightbulb
    CupertinoIcons.nosign, //xmark_octagon//nosign//lightbulb_slash
    CupertinoIcons.map, //map
  ];
  final String title;




  @override
  _DashBoardTest1 createState() => _DashBoardTest1();
}

class _DashBoardTest1 extends State<DashBoardTest1>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  double radius = 80, radius2 = 80;
  StreamSubscription<ConnectivityResult> subscription;
  int activeHours = 72, inActiveHours = 72;
  List<DeviceJason> duplicatedDevices = [];
  List<DeviceJason> activeDevices = [];
  List<DeviceJason> inActiveDevices = [];
  var timer;
  var focusNode;
  bool drawerOpen = false;
  AdvancedSearch advancedSearch;

  String clientAd = "", simProviderAd = "";
  TextEditingController batchNumAd = new TextEditingController(),
      activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      lastSignalAd = new TextEditingController();

  List<double> values = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  double selectedLon = 500;
  double selectedLat = 500;
  String selectedTitle = '';
  List<LatLng> positions = [];

  var icons = [];

  bool loading = false;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  final LatLng _center = const LatLng(2.944590144570856, 101.60274569735296);
  MapType mapType = MapType.hybrid;
  PreloadPageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  Animation<double> _animation;
  AnimationController _animationController;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    try {
      mapController = controller;
      final greenIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), 'assets/image/marker.png');
      final yellowIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)),
          'assets/image/yellowmarker.png');
      final redIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), 'assets/image/redmarker.png');
      icons = [greenIcon, yellowIcon, redIcon];
      await getLocations();
    } catch (error) {
      toast(error.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    focusNode = FocusNode();
    subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController = PreloadPageController(
        initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      toast("internet disconnected");
    } else {
      getLocations();
      client = await RemoteApi.getClientList();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocations();
    }
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _animationController.reverse();
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  DateTime currentBackPressTime;

  var white = Colors.white, black = Color(0xff0065a3);

  @override
  Widget build(BuildContext context) {
    dashBoardContext =context;

    if (advancedSearch == null)
      advancedSearch =
          AdvancedSearch(context, getLocations, new TextEditingController());

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    TextEditingController activeController = new TextEditingController()
      ..text = activeHours.toString();
    activeController.selection = new TextSelection(
      baseOffset: 0,
      extentOffset: activeHours.toString().length,
    );

    TextEditingController inActiveController = new TextEditingController()
      ..text = inActiveHours.toString();
    inActiveController.selection = new TextSelection(
      baseOffset: 0,
      extentOffset: inActiveHours.toString().length,
    );

    final containers = [
      Container(
        child: RefreshIndicator(
          onRefresh: getLocations,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   height: width / 2 + 10,
                  //   padding: EdgeInsets.all(5),
                  //   // color: Color(0xf2f0f0f0),
                  //   child: AnimationLimiter(
                  //     child: GridView.count(
                  //       crossAxisCount: 2,
                  //       physics: NeverScrollableScrollPhysics(),
                  //       childAspectRatio: 1,
                  //       children: List.generate(
                  //         2,
                  //         (int index) {
                  //           return AnimationConfiguration.staggeredGrid(
                  //             position: index,
                  //             duration: const Duration(milliseconds: 500),
                  //             columnCount: 1,
                  //             child: ScaleAnimation(
                  //               child: FadeInAnimation(
                  //                 child: Container(
                  //                   height: 70,
                  //                   // decoration: BoxDecoration(
                  //                   //   // color: Colors.white.withOpacity(0.9),
                  //                   //   borderRadius: BorderRadius.circular(20),
                  //                   //   boxShadow: [
                  //                   //     BoxShadow(
                  //                   //         color: Colors.grey.withOpacity(0.5),
                  //                   //         spreadRadius: 1,
                  //                   //         blurRadius: 3,
                  //                   //         offset: Offset(0, 2))
                  //                   //   ],
                  //                   //   color: Colors.white,
                  //                   // ),
                  //                   margin: EdgeInsets.all(5),
                  //                   padding: EdgeInsets.all(10),
                  //                   // color: Colors.white,
                  //                   child: Stack(
                  //                     // crossAxisAlignment: CrossAxisAlignment.center,
                  //                     children: [
                  //                       Align(
                  //                         alignment: Alignment.topCenter,
                  //                         child: Text(
                  //                           elem[index],
                  //                           textAlign: TextAlign.center,
                  //                           style: TextStyle(
                  //                               fontSize: 14, color: Colors.grey),
                  //                         ),
                  //                       ),
                  //                       Align(
                  //                         alignment: Alignment.center,
                  //                         child: Countup(
                  //                           begin: 0,
                  //                           end: values[index],
                  //                           duration: Duration(seconds: 3),
                  //                           separator: ',',
                  //                           style: TextStyle(
                  //                               fontSize: 50,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: Color(0xff0065a3)),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Total projects",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Countup(
                              begin: 0,
                              end: values[2],
                              duration: Duration(seconds: 2),
                              separator: ',',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: PrimaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WidgetSize(
                    onChange: (Size size) {
                      setState(() {
                        radius = (size.height - 80 < width)
                            ? size.height - 80
                            : width;
                      });
                    },
                    child: Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 35),
                        margin:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2))
                          ],
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Active & Inactive projects",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(bottom: 30, top: 50),
                                  height: radius,
                                  width: radius,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircularPercentIndicator(
                                      radius: radius - 80,
                                      animation: true,
                                      animationDuration: 2000,
                                      lineWidth: 20.0,
                                      percent: values[0] / values[2],
                                      center: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Countup(
                                            begin: 0,
                                            end: values[0],
                                            duration: Duration(seconds: 2),
                                            separator: ',',
                                            style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor),
                                          ),
                                          Countup(
                                            begin: values[2],
                                            end: values[1],
                                            duration: Duration(seconds: 2),
                                            separator: ',',
                                            style: TextStyle(
                                                fontSize: 45,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      backgroundColor: Colors.grey,
                                      progressColor: PrimaryColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Column(
                                        children: [
                                          // Container(
                                          //   width: 20,
                                          //   height: 15,
                                          //   child: Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: CircleAvatar(
                                          //       backgroundColor: Colors.purple,
                                          //       radius: 5,
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            width: 20,
                                            height: 15,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xff0065a3),
                                                radius: 5,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 20,
                                            height: 15,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Container(
                                          //   height: 15,
                                          //   child: Align(
                                          //     alignment: Alignment.centerLeft,
                                          //     child: Text(
                                          //       "Total devices",
                                          //       style: TextStyle(fontSize: 14, color: Colors.grey),
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            height: 15,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Active projects last 72 hours",
                                                style: TextStyle(
                                                    // height: 15,
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 15,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Inactive projects last 72 hours",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    // height: 15,
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Loading(
                              loading: loading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView(),
            ],
          ),
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WidgetSize(
              onChange: (Size size) {
                setState(() {
                  radius2 =
                      (size.height - 50 < width) ? size.height - 50 : width;
                });
              },
              child: Expanded(
                child: RefreshIndicator(
                  onRefresh: getLocations,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2))
                          ],
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Active projects",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20, top: 40),
                                  height: radius2 - 20,
                                  width: radius2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircularPercentIndicator(
                                      radius: radius2 - 80,
                                      animation: true,
                                      animationDuration: 2000,
                                      lineWidth: 20.0,
                                      animateFromLastPercent: true,
                                      percent: values[4] / values[2],
                                      center: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                "% ",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.transparent),
                                              ),
                                              Countup(
                                                begin:
                                                    values[3] / values[2] * 100,
                                                end:
                                                    values[4] / values[2] * 100,
                                                duration: Duration(seconds: 2),
                                                separator: ',',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    // fontWeight: FontWeight.bold,
                                                    color: PrimaryColor),
                                              ),
                                              Text(
                                                " %",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          Countup(
                                            begin: values[3],
                                            end: values[4],
                                            duration: Duration(seconds: 2),
                                            separator: ',',
                                            style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Text(
                                                "% ",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.transparent),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      backgroundColor: Colors.grey,
                                      progressColor: PrimaryColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: 20,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xff0065a3),
                                            radius: 5,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Active projects last ",
                                        style: TextStyle(
                                            // height: 15,
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        activeHours.toString(),
                                        style: TextStyle(
                                            // height: 15,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: PrimaryColor),
                                      ),
                                      Text(
                                        " hours",
                                        style: TextStyle(
                                            // height: 15,
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Loading(
                              loading: loading,
                            ),
                          ],
                        ),
                      ),
                      ListView(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 150,
              margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2))
                ],
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Edit last hours",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onTap: () {
                                    if (activeHours > 0) {
                                      setState(() {
                                        --activeHours;
                                      });
                                      getActive();
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: PrimaryColor,
                                    size: 40.0,
                                  ),
                                )),
                            onTapDown: (TapDownDetails details) {
                              timer = Timer.periodic(Duration(milliseconds: 50),
                                  (t) {
                                if (activeHours > 0) {
                                  setState(() {
                                    --activeHours;
                                  });
                                }
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              timer.cancel();
                              getActive();
                            },
                            onTapCancel: () {
                              timer.cancel();
                              getActive();
                            },
                          ),
                          Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onTap: () {
                                AwesomeDialog(
                                  dialogBackgroundColor: Colors.white,
                                  // padding: EdgeInsets.all(0),
                                  context: context,
                                  btnCancelColor: Colors.red,
                                  btnOkColor: PrimaryColor,
                                  btnOkIcon: Icons.check_circle,
                                  btnCancelIcon: Icons.cancel,
                                  btnOkText: "Submit",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      activeHours =
                                          getInteger(activeController.text);
                                      getActive();
                                    });
                                  },
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Edit last hours",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        textAlign: TextAlign.center,
                                        controller: activeController,
                                        decoration: InputDecoration(
                                          // filled: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                        ),
                                        style: TextStyle(
                                          // height: 15,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: PrimaryColor,
                                        ),
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Spacer(),
                                      //     Material(
                                      //       color: Colors.transparent,
                                      //       child: InkWell(
                                      //         onTap: () => null,
                                      //         child: Padding(
                                      //           padding: EdgeInsets.all(10),
                                      //           child: Text(
                                      //             "Cancel",
                                      //             style: TextStyle(
                                      //                 color: Colors.black),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Material(
                                      //       color: Colors.transparent,
                                      //       child: InkWell(
                                      //         onTap: () => null,
                                      //         child: Padding(
                                      //           padding: EdgeInsets.all(10),
                                      //           child: Text(
                                      //             "Submit",
                                      //             style: TextStyle(
                                      //                 color: PrimaryColor),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 10,
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                )..show();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  activeHours.toString(),
                                  style: TextStyle(
                                      // height: 15,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: PrimaryColor),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onTap: () {
                                    setState(() {
                                      ++activeHours;
                                    });
                                    getActive();
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: PrimaryColor,
                                    size: 40.0,
                                  ),
                                )),
                            onTapDown: (TapDownDetails details) {
                              timer = Timer.periodic(Duration(milliseconds: 50),
                                  (t) {
                                setState(() {
                                  ++activeHours;
                                });
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              timer.cancel();
                              getActive();
                              // toast("msg");
                            },
                            onTapCancel: () {
                              timer.cancel();
                              getActive();
                              // toast("msg");
                            },
                          ),

                          // RawMaterialButton(
                          //   onLongPress: () {},
                          //   onPressed: () {
                          //     setState(() {
                          //       ++activeHours;
                          //     });
                          //     getActive();
                          //   },
                          //   elevation: 0.0,
                          //   fillColor: Colors.white,
                          //   child: Icon(
                          //     Icons.add,
                          //     color: PrimaryColor,
                          //     size: 30.0,
                          //   ),
                          //   // padding: EdgeInsets.all(15.0),
                          //   shape: CircleBorder(),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(5),
                        color: PrimaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showActive(),
                          child: Container(
                            height: 35,
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Show on maps",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Icon(
                                    CupertinoIcons.map,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 10,right: 10,),
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all<Color>(PrimaryColor),
            //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //           side: BorderSide(color: Colors.black12),
            //         ),
            //       ),
            //     ),
            //     onPressed: () => null,
            //     child: Center(
            //       child: Container(
            //         height: 30,
            //         child: Row(
            //           children: [
            //             Spacer(),
            //             Text(
            //               "Show on google maps",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(5),
            //               child: Image(
            //                 color: null,
            //                 image: AssetImage('assets/image/google_maps.png'),
            //               ),
            //             ),
            //             Spacer(),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: getLocations,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2))
                        ],
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Inactive projects",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                padding: EdgeInsets.only(bottom: 20, top: 40),
                                height: radius2 - 20,
                                width: radius2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircularPercentIndicator(
                                    radius: radius2 - 80,
                                    animation: true,
                                    animationDuration: 2000,
                                    lineWidth: 20.0,
                                    // startAngle: 180,
                                    animateFromLastPercent: true,
                                    percent: values[6] / values[2],
                                    center: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            Text(
                                              "% ",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.transparent),
                                            ),
                                            Countup(
                                              begin:
                                                  values[5] / values[2] * 100,
                                              end: values[6] / values[2] * 100,
                                              duration: Duration(seconds: 2),
                                              separator: ',',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  // fontWeight: FontWeight.bold,
                                                  color: PrimaryColor),
                                            ),
                                            Text(
                                              " %",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        Countup(
                                          begin: values[5],
                                          end: values[6],
                                          duration: Duration(seconds: 2),
                                          separator: ',',
                                          style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            Text(
                                              "% ",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.transparent),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    backgroundColor: Colors.grey,
                                    progressColor: PrimaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: 20,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff0065a3),
                                          radius: 5,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Inactive projects last ",
                                      style: TextStyle(
                                          // height: 15,
                                          fontSize: 14,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      inActiveHours.toString(),
                                      style: TextStyle(
                                          // height: 15,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: PrimaryColor),
                                    ),
                                    Text(
                                      " hours",
                                      style: TextStyle(
                                          // height: 15,
                                          fontSize: 14,
                                          color: Colors.grey),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Loading(
                            loading: loading,
                          ),
                        ],
                      ),
                    ),
                    ListView(),
                  ],
                ),
              ),
            ),
            Container(
              height: 150,
              margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2))
                ],
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Edit last hours",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onTap: () {
                                    if (inActiveHours > 0) {
                                      setState(() {
                                        --inActiveHours;
                                      });
                                      getInactive();
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: PrimaryColor,
                                    size: 40.0,
                                  ),
                                )),
                            onTapDown: (TapDownDetails details) {
                              timer = Timer.periodic(Duration(milliseconds: 50),
                                  (t) {
                                if (inActiveHours > 0) {
                                  setState(() {
                                    --inActiveHours;
                                  });
                                }
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              timer.cancel();
                              getInactive();
                            },
                            onTapCancel: () {
                              timer.cancel();
                              getInactive();
                            },
                          ),
                          Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onTap: () {
                                AwesomeDialog(
                                  dialogBackgroundColor: Colors.white,
                                  // padding: EdgeInsets.all(0),
                                  context: context,
                                  btnCancelColor: Colors.red,
                                  btnOkColor: PrimaryColor,
                                  btnOkIcon: Icons.check_circle,
                                  btnCancelIcon: Icons.cancel,
                                  btnOkText: "Submit",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(() {
                                      inActiveHours =
                                          getInteger(inActiveController.text);
                                      getInactive();
                                    });
                                  },
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.NO_HEADER,
                                  body: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Edit last hours",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        textAlign: TextAlign.center,
                                        controller: inActiveController,
                                        decoration: InputDecoration(
                                          // filled: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                        ),
                                        style: TextStyle(
                                          // height: 15,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: PrimaryColor,
                                        ),
                                        focusNode: focusNode,
                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Spacer(),
                                      //     Material(
                                      //       color: Colors.transparent,
                                      //       child: InkWell(
                                      //         onTap: () => null,
                                      //         child: Padding(
                                      //           padding: EdgeInsets.all(10),
                                      //           child: Text(
                                      //             "Cancel",
                                      //             style: TextStyle(
                                      //                 color: Colors.black),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Material(
                                      //       color: Colors.transparent,
                                      //       child: InkWell(
                                      //         onTap: () => null,
                                      //         child: Padding(
                                      //           padding: EdgeInsets.all(10),
                                      //           child: Text(
                                      //             "Submit",
                                      //             style: TextStyle(
                                      //                 color: PrimaryColor),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 10,
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                )..show();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  inActiveHours.toString(),
                                  style: TextStyle(
                                      // height: 15,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: PrimaryColor),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onTap: () {
                                    setState(() {
                                      ++inActiveHours;
                                    });
                                    getInactive();
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: PrimaryColor,
                                    size: 40.0,
                                  ),
                                )),
                            onTapDown: (TapDownDetails details) {
                              timer = Timer.periodic(Duration(milliseconds: 50),
                                  (t) {
                                setState(() {
                                  ++inActiveHours;
                                });
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              timer.cancel();
                              getInactive();
                              // toast("msg");
                            },
                            onTapCancel: () {
                              timer.cancel();
                              getInactive();
                              // toast("msg");
                            },
                          ),

                          // RawMaterialButton(
                          //   onLongPress: () {},
                          //   onPressed: () {
                          //     setState(() {
                          //       ++activeHours;
                          //     });
                          //     getActive();
                          //   },
                          //   elevation: 0.0,
                          //   fillColor: Colors.white,
                          //   child: Icon(
                          //     Icons.add,
                          //     color: PrimaryColor,
                          //     size: 30.0,
                          //   ),
                          //   // padding: EdgeInsets.all(15.0),
                          //   shape: CircleBorder(),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(5),
                        color: PrimaryColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showInActive(),
                          child: Container(
                            height: 35,
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Show on maps",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Icon(
                                    CupertinoIcons.map,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 10,right: 10,),
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all<Color>(PrimaryColor),
            //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //           side: BorderSide(color: Colors.black12),
            //         ),
            //       ),
            //     ),
            //     onPressed: () => null,
            //     child: Center(
            //       child: Container(
            //         height: 30,
            //         child: Row(
            //           children: [
            //             Spacer(),
            //             Text(
            //               "Show on google maps",
            //               style: TextStyle(
            //                   fontSize: 15, fontWeight: FontWeight.bold),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(5),
            //               child: Image(
            //                 color: null,
            //                 image: AssetImage('assets/image/google_maps.png'),
            //               ),
            //             ),
            //             Spacer(),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
      Container(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: "Locate",
                iconColor: Colors.white,
                bubbleColor: PrimaryColor,
                icon: Icons.my_location,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  if (positions.isNotEmpty) {
                    mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(_bounds(positions), 20));
                  } else {
                    mapController
                        .animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
                  }
                },
              ),
              Bubble(
                title: "Search",
                iconColor: Colors.white,
                bubbleColor: PrimaryColor,
                icon: Icons.search,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  advancedSearch.show();
                },
              ),
              Bubble(
                title: "Refresh",
                iconColor: Colors.white,
                bubbleColor: PrimaryColor,
                icon: Icons.refresh,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  advancedSearch.reset();
                  getLocations();
                },
              ),
              // Bubble(
              //   title: "Satellite",
              //   iconColor: Colors.white,
              //   bubbleColor: PrimaryColor,
              //   icon: Icons.satellite,
              //   titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              //   onPress: () {
              //     _animationController.reverse();
              //     setState(() {
              //       mapType = MapType.hybrid;
              //     });
              //   },
              // ),
              // Bubble(
              //   title: "Default",
              //   iconColor: Colors.white,
              //   bubbleColor: PrimaryColor,
              //   icon: Icons.map,
              //   titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              //   onPress: () {
              //     _animationController.reverse();
              //     setState(() {
              //       mapType = MapType.normal;
              //     });
              //   },
              // ),
              // Bubble(
              //   title: "Terrain",
              //   iconColor: Colors.white,
              //   bubbleColor: PrimaryColor,
              //   icon: Icons.terrain,
              //   titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              //   onPress: () {
              //     _animationController.reverse();
              //     setState(() {
              //       mapType = MapType.terrain;
              //     });
              //   },
              // ),
            ],
            animation: _animation,
            onPress: () {
              // toast(_animationController.isCompleted.toString());
              if (_animationController.isCompleted) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
            iconColor: PrimaryColor,
            icon: AnimatedIcons.menu_close,
          ),
          body: Stack(
            children: [
              GoogleMap(
                onTap: (v) => _animationController.reverse(),
                onMapCreated: _onMapCreated,
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer())),
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: false,
                mapType: mapType,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 4,
                ),
                markers: Set<Marker>.of(markers.values), // YOUR
              ),
              Loading(
                loading: loading,
                color: Color(0xFFFFFFFF),
              ),
            ],
          ),
        ),
      ),
    ];

    return Container(
      color: Color(0xffF6F7FA),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage("assets/image/gradient2.jpg"), fit: BoxFit.cover),
      // ),
      child: GestureDetector(
        onTap: () {
          _animationController.reverse();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
              // padding: EdgeInsets.only(left: 10,right: 10),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2))
                ],
                color: white,
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(10.0),
                //   topLeft: Radius.circular(10.0),
                // ),
              ),
              child: BubbledNavigationBar(
                controller: _menuPositionController,
                initialIndex: 0,
                itemMargin: EdgeInsets.only(left: 20),
                backgroundColor: Colors.transparent,
                defaultBubbleColor: black,
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    curve: Curves.easeInOutQuad,
                    duration: Duration(milliseconds: 500),
                  );
                },
                items: widget.titles.map((title) {
                  var index = widget.titles.indexOf(title);
                  var color = black;
                  return BubbledNavigationBarItem(
                    icon: getIcon(index, color),
                    activeIcon: getIcon(index, white),
                    bubbleColor: color,
                    title: Text(
                      title,
                      style: TextStyle(color: white, fontSize: 12),
                    ),
                  );
                }).toList(),
              )),
          backgroundColor: Colors.transparent,
          appBar: CostumeAppBar('DASHBOARD'),
          drawer: SideDrawerAdmin(
            setOpen: isOpen,
          ),
          body: WillPopScope(
            // child: Stack(
            //   children: [
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                checkUserDragging(scrollNotification);
                return;
              },
              child: PreloadPageView.builder(
                // controller: _pageController,
                // children: containers.map((Container c) => c).toList(),
                // physics: NeverScrollableScrollPhysics(), // add this
                controller: _pageController,
                preloadPagesCount: 4,
                itemCount: 4,
                onPageChanged: (page) {
                  _animationController.reverse();
                },
                itemBuilder: (BuildContext context, int index) {
                  return containers[index];
                },
              ),
            ),
            // Loading(
            //   loading: loading,
            //   color: color,
            // ),
            // ],
            // ),
            onWillPop: onWillPop,
          ),
        ),
      ),
    );
  }

  // Future<void> refresh() async {}

  void isOpen(bool isOpen) {
    drawerOpen = isOpen;
  }

  Future<bool> onWillPop() {
    if (!drawerOpen) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        toast("Press back again to exit");
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  // void advancedSearch() {
  //   Navigator.of(context).push(
  //     new MaterialPageRoute<String>(
  //         builder: (BuildContext context) {
  //           return new Scaffold(
  //             backgroundColor: Color(0xfafafafa),
  //             appBar: new AppBar(
  //               centerTitle: true,
  //               backgroundColor: Color(0xff0065a3),
  //               title: const Text('Search'),
  //               actions: [
  //                 IconButton(
  //                   icon: Icon(
  //                     Icons.restart_alt,
  //                     color: Colors.white,
  //                   ),
  //                   onPressed: () {
  //                     Navigator.pop(this.context);
  //                     reset();
  //                   },
  //                 )
  //               ],
  //             ),
  //             body: GestureDetector(
  //               onTap: () {
  //                 FocusScopeNode currentFocus = FocusScope.of(context);
  //                 if (!currentFocus.hasPrimaryFocus &&
  //                     currentFocus.focusedChild != null) {
  //                   FocusManager.instance.primaryFocus.unfocus();
  //                 }
  //               },
  //               child: SingleChildScrollView(
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   padding: EdgeInsets.all(15),
  //                   color: Color(0xfafafafa),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Client',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       ModalFilter(clientAd, "Client", client,
  //                           (val) => clientAd = val, "", false),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Client Batch Number',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartField(
  //                         controller: batchNumAd,
  //                         hintText: "Client Batch Number",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Activation Date From',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: activationFromAd,
  //                         hintText: "Activation Date From",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Activation Date To',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: activationToAd,
  //                         hintText: "Activation Date To",
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Sim Provider',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       ModalFilter(
  //                           simProviderAd,
  //                           "Sim Provider",
  //                           simCardProvider,
  //                           (val) => simProviderAd = val,
  //                           "",
  //                           false),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Last Signal From',
  //                         style: TextStyle(fontSize: 16.0, color: Colors.black),
  //                       ),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       SmartDate(
  //                         controller: lastSignalAd,
  //                         hintText: "Last Signal From",
  //                       ),
  //                       SizedBox(
  //                         height: 70,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             floatingActionButton: FloatingActionButton(
  //               onPressed: () {
  //                 if (clientAd == "" &&
  //                     simProviderAd == "" &&
  //                     batchNumAd.text == "" &&
  //                     activationFromAd.text == "" &&
  //                     activationToAd.text == "" &&
  //                     lastSignalAd.text == "") {
  //                   toast("Please fill in any field to search");
  //                   return;
  //                 }
  //                 advancedSearchBool = true;
  //                 Navigator.pop(this.context);
  //                 getLocations();
  //               },
  //               child: const Icon(Icons.search),
  //               backgroundColor: Color(0xff0065a3),
  //             ),
  //           );
  //         },
  //         fullscreenDialog: true),
  //   );
  // }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
  }

  Future<void> getLocations() async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    await getDevices();
    setState(() {
      loading = false;
    });
  }


  Future<void> getDevices() async {
    try {
      devices = await RemoteApi.getDevicesList();
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) {
        if (message != null) {
          Navigator.push(
            context,
            SizeRoute(
              page: DeviceHistory(),
            ),
          );
        }
      });
      setState(() {
        markers.clear();
        positions.clear();
        double total = 0, inActiveLast72 = 0;
        devices.forEach((device) {
          total++;
          if (device.inActiveLast72()) {
            inActiveLast72++;
          }
          if (advancedSearch.filterDevice(device)) {
            if (device.lat != 500 && device.lon != 500) {
              addMarker(device);
              positions.add(new LatLng(device.lat, device.lon));
            }
          }
        });
        this.values[0] = (total - inActiveLast72);
        this.values[1] = inActiveLast72;
        this.values[2] = total;
        this.duplicatedDevices.clear();
        this.duplicatedDevices.addAll(devices);
        getActive();
        getInactive();
        if (positions.isNotEmpty) {
          mapController.animateCamera(
              CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        } else {
          toast("No device was found!");
          mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        }
      });
    } catch (error) {
      // toast('Error: ' + error.message);
    }
  }

  void getActive() {
    this.activeDevices.clear();
    double counter = 0;
    this.duplicatedDevices.forEach((element) {
      if (!element.inActiveSince(activeHours)) {
        this.activeDevices.add(element);
        counter++;
      }
    });
    setState(() {
      values[3] = values[4];
      values[4] = counter;
    });
  }

  void getInactive() {
    this.inActiveDevices.clear();
    double counter = 0;
    this.duplicatedDevices.forEach((element) {
      if (element.inActiveSince(inActiveHours)) {
        this.inActiveDevices.add(element);
        counter++;
      }
    });
    setState(() {
      values[5] = values[6];
      values[6] = counter;
    });
  }

  // bool filter(DeviceJason device) {
  //   bool clientBool = (clientAd.isEmpty ||
  //       client[getInt(device.client) - 1].contains(clientAd));
  //   bool batchBool = (batchNumAd.text.isEmpty ||
  //       device.batchNum.toLowerCase().contains(batchNumAd.text.toString()));
  //   bool activationFromBool;
  //   try {
  //     activationFromBool = (activationFromAd.text.isEmpty ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAfter(DateFormat('dd-MM-yyyy').parse(activationFromAd.text)) ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
  //   } catch (Exception) {
  //     activationFromBool = false;
  //   }
  //   bool activationToBool;
  //   try {
  //     activationToBool = (activationToAd.text.isEmpty ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isBefore(DateFormat('dd-MM-yyyy').parse(activationToAd.text)) ||
  //         DateFormat('dd-MM-yyyy')
  //             .parse(device.activationDate)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(activationToAd.text)));
  //   } catch (Exception) {
  //     activationToBool = false;
  //   }
  //   bool simBool =
  //       (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));
  //
  //   bool lastSignalBool;
  //   try {
  //     lastSignalBool = (lastSignalAd.text.isEmpty ||
  //         DateFormat('yyyy-MM-dd HH:mm:ss')
  //             .parse(device.lastSignal)
  //             .isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)) ||
  //         DateFormat('yyyy-MM-dd HH:mm:ss')
  //             .parse(device.lastSignal)
  //             .isAtSameMomentAs(
  //                 DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));
  //   } catch (Exception) {
  //     lastSignalBool = false;
  //   }
  //
  //   if (clientBool &&
  //       batchBool &&
  //       activationFromBool &&
  //       activationToBool &&
  //       simBool &&
  //       lastSignalBool) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  int getInteger(String str) {
    String intString = "";
    for (int i = 1; i <= str.length; i++) {
      String temp = str.substring(i - 1, i);
      if (isInt(temp)) {
        intString += temp;
      }
    }
    try {
      return int.parse(intString);
    } catch (Exception) {
      return 0;
    }
  }

  bool isInt(String str) {
    try {
      int.parse(str);
      return true;
    } catch (Exception) {
      return false;
    }
  }

  void addMarker(DeviceJason device) {
    markers[MarkerId(device.id)] = Marker(
      onTap: () {
        selectedLat = device.lat;
        selectedLon = device.lon;
        selectedTitle = device.deviceDetails;
        ShowDevice(this.context, device);
        // _animationController.forward();
      },
      anchor: const Offset(0.5, 0.5),
      markerId: MarkerId(device.id),
      position: LatLng(device.lat, device.lon),
      infoWindow: InfoWindow(
        title: device.deviceName,
      ),
      icon: icons[device.icon],
      draggable: false,
      zIndex: 1,
    );
  }

  void showDevice(BuildContext context, String deviceId) {
    ShowDevice(
      context,
      duplicatedDevices.firstWhere((device) => device.id == deviceId,
          orElse: () => null),
    );
  }

  void showActive() {
    setState(() {
      _pageController.animateToPage(
        3,
        curve: Curves.easeInOutQuad,
        duration: Duration(milliseconds: 500),
      );
      _menuPositionController.animateToPosition(
        3,
        curve: Curves.easeInOutQuad,
        duration: Duration(milliseconds: 500),
      );
      markers.clear();
      positions.clear();
      activeDevices.forEach((device) {
        if (device.lat != 500 && device.lon != 500) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      if (positions.isNotEmpty) {
        mapController.animateCamera(
            CameraUpdate.newLatLngBounds(_bounds(positions), 20));
      } else {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        toast("No device was found on the map");
      }
    });
  }

  void showInActive() {
    setState(() {
      _pageController.animateToPage(
        3,
        curve: Curves.easeInOutQuad,
        duration: Duration(milliseconds: 500),
      );
      _menuPositionController.animateToPosition(
        3,
        curve: Curves.easeInOutQuad,
        duration: Duration(milliseconds: 500),
      );
      markers.clear();
      positions.clear();
      inActiveDevices.forEach((device) {
        if (device.lat != 500 && device.lon != 500) {
          addMarker(device);
          positions.add(new LatLng(device.lat, device.lon));
        }
      });
      if (positions.isNotEmpty) {
        mapController.animateCamera(
            CameraUpdate.newLatLngBounds(_bounds(positions), 20));
      } else {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(_center, 4));
        toast("No device was found on the map");
      }
    });
  }

  // void reset() {
  //   clientAd = "";
  //   simProviderAd = "";
  //   batchNumAd.text = "";
  //   activationFromAd.text = "";
  //   activationToAd.text = "";
  //   lastSignalAd.text = "";
  //   getLocations();
  // }

  LatLngBounds _bounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }
}
