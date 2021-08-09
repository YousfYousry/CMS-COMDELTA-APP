import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/DeviceLogsAppBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'dart:math' as math;

import 'package:substring_highlight/substring_highlight.dart';

const PrimaryColor = const Color(0xff0065a3);

class DeviceLogs extends StatefulWidget {
  @override
  _DeviceLogs createState() => _DeviceLogs();
}

var spanUp = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortup.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDown = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 2, bottom: 2),
        child: ImageIcon(
          AssetImage('assets/image/sortdown.png'),
          size: 12,
          color: Colors.black,
        ),
      ),
    ),
    spanDefault = WidgetSpan(
      child: Transform.rotate(
          angle: 90 * math.pi / 180,
          child: Icon(
            Icons.sync_alt,
            size: 15,
            color: Colors.grey,
          )),
    );

class _DeviceLogs extends State<DeviceLogs> with WidgetsBindingObserver {
  TextEditingController searchController = new TextEditingController();
  bool loading = false, validate = false;
  int sortState = 1;

  var span1 = spanUp, span2 = spanDefault, span3 = spanDefault;
  var logs = [];
  var duplicateLogs = [];

  LinkedScrollControllerGroup _controllers;
  ScrollController _letters;
  ScrollController _numbers;

  Widget details(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 13, color: Colors.black.withOpacity(0.6)),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget l123(String title, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              Icons.lightbulb,
              color: value ? Colors.green : Colors.red,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget battery(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2.5,
              ),
              child: ImageIcon(
                AssetImage("assets/battery/battery" + value + ".png"),
                color: Colors.black,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rssi(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2.5,
              ),
              child: ImageIcon(
                AssetImage("assets/rssi/rssi" + value + ".png"),
                color: Colors.black,
                size: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget status(String title, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 110,
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              value ? Icons.check : Icons.close,
              color: value ? Colors.green : Colors.red,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleElement(
      double width, double height, String title, var span, var onTap) {
    return Container(
      width: width,
      height: height,
      child: InkWell(
        onTap: () => setState(() => onTap()),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: title),
                  span,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget value(
      double height, double width, String title, String high, bool border) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: border ? 1.0 : 0, color: Colors.grey),
        ),
      ),
      child: Align(
          alignment: Alignment.centerLeft,
          child: SubstringHighlight(
            text: title,
            term: high,
            textStyleHighlight: TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
    );
  }

  // void _sort1() {
  // if (span1 != spanDown) {
  //   sortState = 0;
  //   devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
  //   span1 = spanDown;
  // } else {
  //   sortState = 1;
  //   devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
  //   span1 = spanUp;
  // }
  // span2 = spanDefault;
  // span3 = spanDefault;
  // }
  //
  // void _sort2() {
  //   if (span2 != spanDown) {
  //     sortState = 2;
  //     devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
  //     span2 = spanDown;
  //   } else {
  //     sortState = 3;
  //     devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
  //     span2 = spanUp;
  //   }
  //   span1 = spanDefault;
  //   span3 = spanDefault;
  // }
  //
  // void _sort3() {
  //   if (span3 != spanDown) {
  //     sortState = 4;
  //     devices.sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
  //     span3 = spanDown;
  //   } else {
  //     sortState = 5;
  //     devices.sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
  //     span3 = spanUp;
  //   }
  //   span2 = spanDefault;
  //   span1 = spanDefault;
  // }
  //
  // void filterSearchResults(String query) {
  //   bool resultFound = false;
  //   var dummySearchList = [];
  //   dummySearchList.addAll(duplicateDevices);
  //   if (query.isNotEmpty) {
  //     var dummyListData = [];
  //     dummySearchList.forEach((item) {
  //       if (item.id.toLowerCase().contains(query.toLowerCase()) ||
  //           item.deviceName.toLowerCase().contains(query.toLowerCase()) ||
  //           item.deviceLocation.toLowerCase().contains(query.toLowerCase())) {
  //         resultFound = true;
  //         item.setHighLight(query);
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       validate = !resultFound;
  //       devices.clear();
  //       devices.addAll(dummyListData);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       validate = false;
  //       span1 = spanUp;
  //       span2 = spanDefault;
  //       span3 = spanDefault;
  //       devices.clear();
  //       devices.addAll(duplicateDevices);
  //       devices.forEach((item) => item.setHighLight(''));
  //     });
  //   }
  // }

  @override
  void initState() {
    getLogs();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _letters.dispose();
    _numbers.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLogs();
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
        backgroundColor: Color(0xfafafafa),
        appBar: PreferredSize(
          child: DeviceLogsAppBar(context, "Device Logs", showDeviceDetails),
          preferredSize: const Size.fromHeight(50),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    // onChanged: (text) => filterSearchResults(text),
                    controller: searchController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      errorText: validate ? 'No result was found' : null,
                      labelText: "Search",
                      hintText: "Search",
                      contentPadding: EdgeInsets.all(20.0),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.black12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleElement(130, 30, "Detail", span1, null),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _letters,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      titleElement(70, 30, "L1#", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L1@", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L2#", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L2@", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L3#", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "L3@", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(
                                          80, 30, "Battery", span2, null),
                                      Container(
                                        height: 30,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      titleElement(70, 30, "Rssi", span2, null),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 131,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 30,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.grey),
                                              bottom: BorderSide(
                                                  width:
                                                      (index != 29) ? 1.0 : 0,
                                                  color: Colors.grey),
                                            ),
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color(0xf1f1f1f1),
                                          ),
                                          height: 30,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: SubstringHighlight(
                                                text: "2021-08-06 17:35:36",
                                                term: "",
                                                textStyleHighlight: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      controller: _numbers,
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: 577,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 30,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: (index != 29)
                                                          ? 1.0
                                                          : 0,
                                                      color: Colors.grey),
                                                ),
                                                color: (index % 2 == 0)
                                                    ? Colors.white
                                                    : Color(0xf1f1f1f1),
                                              ),
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 71, "title", "",
                                                      true),
                                                  value(30, 81, "title", "",
                                                      true),
                                                  value(30, 70, "title", "",
                                                      false),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Column(
                    //   children: [
                    //     Container(
                    //       height: 30,
                    //       color: Colors.black12,
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.stretch,
                    //         children: [
                    //           Expanded(
                    //             flex: 1,
                    //             child: InkWell(
                    //               onTap: () {
                    //                 setState(() {
                    //                   // _sort1();
                    //                 });
                    //               },
                    //               child: MiddleLeft(Padding(
                    //                 padding: EdgeInsets.only(left: 10),
                    //                 child: RichText(
                    //                   text: TextSpan(
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black,
                    //                     ),
                    //                     children: [
                    //                       TextSpan(text: 'ID'),
                    //                       span1,
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )),
                    //             ),
                    //           ),
                    //           Container(
                    //             height: 30,
                    //             width: 1,
                    //             color: Colors.grey,
                    //           ),
                    //           Expanded(
                    //             flex: 4,
                    //             child: InkWell(
                    //               onTap: () {
                    //                 setState(() {
                    //                   // _sort2();
                    //                 });
                    //               },
                    //               child: MiddleLeft(Padding(
                    //                 padding: EdgeInsets.only(left: 10),
                    //                 child: RichText(
                    //                   text: TextSpan(
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black,
                    //                     ),
                    //                     children: [
                    //                       TextSpan(text: 'Device Name'),
                    //                       span2,
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )),
                    //             ),
                    //           ),
                    //           Container(
                    //             height: 30,
                    //             width: 1,
                    //             color: Colors.grey,
                    //           ),
                    //           Expanded(
                    //             flex: 2,
                    //             child: InkWell(
                    //               onTap: () {
                    //                 setState(() {
                    //                   // _sort3();
                    //                 });
                    //               },
                    //               child: MiddleLeft(Padding(
                    //                 padding: EdgeInsets.only(left: 10),
                    //                 child: RichText(
                    //                   text: TextSpan(
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.black,
                    //                     ),
                    //                     children: [
                    //                       TextSpan(text: 'Location'),
                    //                       span3,
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //       height: 1,
                    //       width: double.infinity,
                    //       color: Colors.grey,
                    //     ),
                    //     // Expanded(
                    //     //   child: Container(
                    //     //     decoration: new BoxDecoration(color: Colors.white),
                    //     //     child: ListView.builder(
                    //     //       itemCount: devices.length,
                    //     //       itemBuilder: (context, index) {
                    //     //         return Slidable(
                    //     //           actionPane: SlidableDrawerActionPane(),
                    //     //           actionExtentRatio: 0.20,
                    //     //           child: new Column(
                    //     //             children: [
                    //     //               Material(
                    //     //                 color: (index % 2 == 0)
                    //     //                     ? Colors.white
                    //     //                     : Color(0xf1f1f1f1),
                    //     //                 child: InkWell(
                    //     //                   onTap: () {
                    //     //                     AwesomeDialog(
                    //     //                       dialogBackgroundColor:
                    //     //                           Color(0xfafafafa),
                    //     //                       context: context,
                    //     //                       animType: AnimType.SCALE,
                    //     //                       dialogType: DialogType.NO_HEADER,
                    //     //                       body: Padding(
                    //     //                         padding: EdgeInsets.only(
                    //     //                             left: 15, right: 15),
                    //     //                         child: Column(
                    //     //                           mainAxisAlignment:
                    //     //                               MainAxisAlignment.center,
                    //     //                           crossAxisAlignment:
                    //     //                               CrossAxisAlignment.center,
                    //     //                           children: [
                    //     //                             details('ID',
                    //     //                                 devices[index].id),
                    //     //                             details(
                    //     //                                 'Device Name',
                    //     //                                 devices[index]
                    //     //                                     .deviceName),
                    //     //                             details(
                    //     //                                 'Device Detail',
                    //     //                                 devices[index]
                    //     //                                     .deviceDetails),
                    //     //                             details(
                    //     //                                 'Height',
                    //     //                                 devices[index]
                    //     //                                     .deviceHeight),
                    //     //                             details(
                    //     //                                 'Activation Date',
                    //     //                                 devices[index]
                    //     //                                     .activationDate),
                    //     //                             details(
                    //     //                                 'Location',
                    //     //                                 devices[index]
                    //     //                                     .deviceLocation),
                    //     //                             details(
                    //     //                                 'Last Signal',
                    //     //                                 devices[index]
                    //     //                                     .lastSignal),
                    //     //                             l123('L1#',
                    //     //                                 devices[index].l1),
                    //     //                             l123('L2#',
                    //     //                                 devices[index].l2),
                    //     //                             l123('L3#',
                    //     //                                 devices[index].l3),
                    //     //                             battery('Battery',
                    //     //                                 devices[index].battery),
                    //     //                             rssi('Rssi',
                    //     //                                 devices[index].rssi),
                    //     //                             status('Status',
                    //     //                                 devices[index].status),
                    //     //                             ElevatedButton(
                    //     //                               style: ButtonStyle(
                    //     //                                 backgroundColor: MaterialStateProperty.all<
                    //     //                                     Color>((devices[index]
                    //     //                                                 .lat !=
                    //     //                                             500 &&
                    //     //                                         devices[index]
                    //     //                                                 .lon !=
                    //     //                                             500 &&
                    //     //                                         devices[index]
                    //     //                                             .deviceName
                    //     //                                             .isNotEmpty)
                    //     //                                     ? PrimaryColor
                    //     //                                     : Colors.grey),
                    //     //                                 shape: MaterialStateProperty
                    //     //                                     .all<
                    //     //                                         RoundedRectangleBorder>(
                    //     //                                   RoundedRectangleBorder(
                    //     //                                     borderRadius:
                    //     //                                         BorderRadius
                    //     //                                             .circular(
                    //     //                                                 10),
                    //     //                                     side: BorderSide(
                    //     //                                         color: Colors
                    //     //                                             .black12),
                    //     //                                   ),
                    //     //                                 ),
                    //     //                               ),
                    //     //
                    //     //                               onPressed: () => (devices[
                    //     //                                                   index]
                    //     //                                               .lat !=
                    //     //                                           500 &&
                    //     //                                       devices[
                    //     //                                                   index]
                    //     //                                               .lon !=
                    //     //                                           500 &&
                    //     //                                       devices[
                    //     //                                               index]
                    //     //                                           .deviceName
                    //     //                                           .isNotEmpty)
                    //     //                                   ? MapsLauncher
                    //     //                                       .launchCoordinates(
                    //     //                                           devices[index]
                    //     //                                               .lat,
                    //     //                                           devices[index]
                    //     //                                               .lon,
                    //     //                                           devices[index]
                    //     //                                               .deviceName)
                    //     //                                   : toast(
                    //     //                                       "Location is unavailable")
                    //     //                               // if (lat != 500 && lon != 500 && title.isNotEmpty) {
                    //     //                               //   MapsLauncher.launchCoordinates(lat, lon, title);
                    //     //                               // }
                    //     //                               ,
                    //     //                               // tooltip: 'Google maps',
                    //     //                               child: Center(
                    //     //                                 child: Container(
                    //     //                                   height: 30,
                    //     //                                   child: Row(
                    //     //                                     children: [
                    //     //                                       Spacer(),
                    //     //                                       Text(
                    //     //                                         "Show on google maps",
                    //     //                                         style: TextStyle(
                    //     //                                             color: (devices[index].lat != 500 &&
                    //     //                                                     devices[index].lon !=
                    //     //                                                         500 &&
                    //     //                                                     devices[index]
                    //     //                                                         .deviceName
                    //     //                                                         .isNotEmpty)
                    //     //                                                 ? null
                    //     //                                                 : Colors
                    //     //                                                     .black54,
                    //     //                                             fontSize:
                    //     //                                                 15,
                    //     //                                             fontWeight:
                    //     //                                                 FontWeight
                    //     //                                                     .bold),
                    //     //                                       ),
                    //     //                                       Padding(
                    //     //                                         padding:
                    //     //                                             EdgeInsets
                    //     //                                                 .all(5),
                    //     //                                         child: Image(
                    //     //                                           color: (devices[index].lat != 500 &&
                    //     //                                                   devices[index].lon !=
                    //     //                                                       500 &&
                    //     //                                                   devices[index]
                    //     //                                                       .deviceName
                    //     //                                                       .isNotEmpty)
                    //     //                                               ? null
                    //     //                                               : Colors
                    //     //                                                   .black54,
                    //     //                                           image: AssetImage(
                    //     //                                               'assets/image/google_maps.png'),
                    //     //                                         ),
                    //     //                                       ),
                    //     //                                       Spacer(),
                    //     //                                     ],
                    //     //                                   ),
                    //     //                                 ),
                    //     //                               ),
                    //     //                             ),
                    //     //                           ],
                    //     //                         ),
                    //     //                       ),
                    //     //                       title: 'This is Ignored',
                    //     //                       desc: 'This is also Ignored',
                    //     //                     )..show();
                    //     //                   },
                    //     //                   child: Container(
                    //     //                     height: 40,
                    //     //                     child: Row(
                    //     //                       children: [
                    //     //                         Expanded(
                    //     //                           flex: 1,
                    //     //                           child: Padding(
                    //     //                             padding: EdgeInsets.only(
                    //     //                                 left: 10),
                    //     //                             child: SubstringHighlight(
                    //     //                               text: devices[index].id,
                    //     //                               term: devices[index]
                    //     //                                   .highLight,
                    //     //                               textStyleHighlight:
                    //     //                                   TextStyle(
                    //     //                                 fontSize: 13,
                    //     //                                 color: Colors.red,
                    //     //                                 fontWeight:
                    //     //                                     FontWeight.bold,
                    //     //                               ),
                    //     //                               textStyle: TextStyle(
                    //     //                                 fontSize: 12,
                    //     //                                 color: Colors.black,
                    //     //                               ),
                    //     //                             ),
                    //     //
                    //     //                             // Text(
                    //     //                             //   ID,
                    //     //                             //   textAlign: TextAlign.left,
                    //     //                             //   style: TextStyle(fontSize: 12),
                    //     //                             // ),
                    //     //                           ),
                    //     //                         ),
                    //     //                         Container(
                    //     //                           height: 40,
                    //     //                           width: 1,
                    //     //                           color: Colors.grey,
                    //     //                         ),
                    //     //                         Expanded(
                    //     //                           flex: 4,
                    //     //                           child: Padding(
                    //     //                             padding: EdgeInsets.only(
                    //     //                                 left: 10),
                    //     //                             child: SubstringHighlight(
                    //     //                               text: devices[index]
                    //     //                                   .deviceName,
                    //     //                               term: devices[index]
                    //     //                                   .highLight,
                    //     //                               textStyleHighlight:
                    //     //                                   TextStyle(
                    //     //                                 fontSize: 13,
                    //     //                                 color: Colors.red,
                    //     //                                 fontWeight:
                    //     //                                     FontWeight.bold,
                    //     //                               ),
                    //     //                               textStyle: TextStyle(
                    //     //                                 fontSize: 12,
                    //     //                                 color: Colors.black,
                    //     //                               ),
                    //     //                             ),
                    //     //                             // Text(
                    //     //                             //   Details,
                    //     //                             //   textAlign: TextAlign.left,
                    //     //                             //   style: TextStyle(fontSize: 12),
                    //     //                             // ),
                    //     //                           ),
                    //     //                         ),
                    //     //                         Container(
                    //     //                           height: 40,
                    //     //                           width: 1,
                    //     //                           color: Colors.grey,
                    //     //                         ),
                    //     //                         Expanded(
                    //     //                           flex: 2,
                    //     //                           child: Padding(
                    //     //                             padding: EdgeInsets.only(
                    //     //                                 left: 10),
                    //     //                             child: SubstringHighlight(
                    //     //                               text: devices[index]
                    //     //                                   .deviceLocation,
                    //     //                               term: devices[index]
                    //     //                                   .highLight,
                    //     //                               textStyleHighlight:
                    //     //                                   TextStyle(
                    //     //                                 fontSize: 13,
                    //     //                                 color: Colors.red,
                    //     //                                 fontWeight:
                    //     //                                     FontWeight.bold,
                    //     //                               ),
                    //     //                               textStyle: TextStyle(
                    //     //                                 fontSize: 12,
                    //     //                                 color: Colors.black,
                    //     //                               ),
                    //     //                             ),
                    //     //                             // Text(
                    //     //                             //   Location,
                    //     //                             //   textAlign: TextAlign.left,
                    //     //                             //   style: TextStyle(fontSize: 12),
                    //     //                             // ),
                    //     //                           ),
                    //     //                         ),
                    //     //                       ],
                    //     //                     ),
                    //     //                   ),
                    //     //                 ),
                    //     //               ),
                    //     //               Container(
                    //     //                 height: 1,
                    //     //                 width: double.infinity,
                    //     //                 color: Colors.grey,
                    //     //               ),
                    //     //             ],
                    //     //           ),
                    //     //           actions: [
                    //     //             new IconSlideAction(
                    //     //               caption: 'Logs',
                    //     //               color: Color(0xffFFB61E),
                    //     //               icon: Icons.signal_cellular_alt,
                    //     //               onTap: () => toast('Logs'),
                    //     //             ),
                    //     //             new IconSlideAction(
                    //     //               caption: 'Download',
                    //     //               color: Colors.green,
                    //     //               icon: Icons.download,
                    //     //               onTap: () => toast('Downloading'),
                    //     //             ),
                    //     //           ],
                    //     //           secondaryActions: <Widget>[
                    //     //             new IconSlideAction(
                    //     //               caption: 'Edit',
                    //     //               color: Color(0xff62D0F1),
                    //     //               icon: Icons.edit,
                    //     //               onTap: () => editDevice(devices[index]),
                    //     //             ),
                    //     //             new IconSlideAction(
                    //     //               caption: 'Delete',
                    //     //               color: Color(0xffE5343D),
                    //     //               icon: Icons.delete,
                    //     //               onTap: () {
                    //     //                 AwesomeDialog(
                    //     //                   context: context,
                    //     //                   dialogType: DialogType.WARNING,
                    //     //                   animType: AnimType.BOTTOMSLIDE,
                    //     //                   title: 'Delete Device',
                    //     //                   desc:
                    //     //                       'Do you really want to delete ' +
                    //     //                           devices[index].deviceName,
                    //     //                   btnCancelOnPress: () {},
                    //     //                   btnOkOnPress: () {
                    //     //                     deleteSnack.show();
                    //     //                     sendDeleteReq(devices[index].id);
                    //     //                   },
                    //     //                 )..show();
                    //     //               },
                    //     //             ),
                    //     //           ],
                    //     //         );
                    //     //       },
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                  ),
                ),
              ],
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

  void getLogs() {
    // setState(() {
    //   loading = true;
    // });
    // http
    //     .get(Uri.parse(
    //         'http://103.18.247.174:8080/AmitProject/getLocations.php'))
    //     .then((value) {
    //   List<String> id = [];
    //   List<String> locationName = [];
    //   if (value.statusCode == 200) {
    //     List<dynamic> values = [];
    //     values = json.decode(value.body);
    //     if (values.length > 0) {
    //       for (int i = 0; i < values.length; i++) {
    //         if (values[i] != null) {
    //           Map<String, dynamic> map = values[i];
    //           id.add(map['location_id'].toString());
    //           locationName.add(map['location_name'].toString());
    //         }
    //       }
    //     }
    //     getDevices(id, locationName);
    //   } else {
    //     setState(() {
    //       loading = false;
    //     });
    //     throw Exception("Unable to get locations");
    //   }
    // }).onError((error, stackTrace) {
    //   setState(() {
    //     loading = false;
    //   });
    //   toast('Error: ' + error.message);
    // });
  }

  void showDeviceDetails() {}

// void getDevices(List<String> id, List<String> locationName) {
//   http
//       .get(Uri.parse(
//           'http://103.18.247.174:8080/AmitProject/admin/getDevices.php'))
//       .then((value) {
//     if (value.statusCode == 200) {
//       List<DeviceJason> devices = [];
//       List<dynamic> values = [];
//       values = json.decode(value.body);
//
//       if (values.length > 0) {
//         for (int i = 0; i < values.length; i++) {
//           if (values[i] != null) {
//             Map<String, dynamic> map = values[i];
//             devices.add(DeviceJason.fromJson(
//                 map,
//                 locationName
//                     .elementAt(id.indexOf(map['location_id'].toString()))));
//           }
//         }
//       }
//       showDevices(devices);
//     } else {
//       setState(() {
//         loading = false;
//       });
//       throw Exception("Unable to get device list");
//     }
//   }).onError((error, stackTrace) {
//     setState(() {
//       loading = false;
//     });
//     toast('Error: ' + error.message);
//   });
// }
//
// void showLogs(List<DeviceJason> devices) {
//   setState(() {
//     this.duplicateDevices.clear();
//     this.devices.clear();
//     if (!advancedSearchBool) {
//       // this.duplicateDevices.addAll(devices);
//       this.devices.addAll(devices);
//     } else {
//       addFilteredClients(devices);
//       advancedSearchBool = false;
//     }
//     if (sortState == 0) {
//       this.devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
//     } else if (sortState == 1) {
//       this.devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
//     } else if (sortState == 2) {
//       this.devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
//     } else if (sortState == 3) {
//       this.devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
//     } else if (sortState == 4) {
//       this
//           .devices
//           .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
//     } else if (sortState == 5) {
//       this
//           .devices
//           .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
//     }
//     this.duplicateDevices.addAll(this.devices);
//     loading = false;
//   });
// }
}
