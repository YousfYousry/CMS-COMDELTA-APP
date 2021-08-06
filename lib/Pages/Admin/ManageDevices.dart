import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Pages/Admin/AddEditDevice.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/ManageDevicesAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Functions/random.dart';
import 'package:login_cms_comdelta/Widgets/Others/SizeTransition.dart';
import 'package:login_cms_comdelta/Widgets/Position/MiddleLeft.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/SnackBar.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'dart:math' as math;
import '../../Choices.dart';

const PrimaryColor = const Color(0xff0065a3);

class ManageDevice extends StatefulWidget {
  @override
  _ManageDevice createState() => _ManageDevice();
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

class _ManageDevice extends State<ManageDevice> with WidgetsBindingObserver {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false, advancedSearchBool = false;
  int sortState = 1;
  Snack deleteSnack;

  String clientAd = "", simProviderAd = "";
  TextEditingController batchNumAd = new TextEditingController(),
      activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      lastSignalAd = new TextEditingController();

  var span1 = spanUp, span2 = spanDefault, span3 = spanDefault;
  var devices = [];
  var duplicateDevices = [];

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

  void _sort1() {
    if (span1 != spanDown) {
      sortState = 0;
      devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      span1 = spanDown;
    } else {
      sortState = 1;
      devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      span1 = spanUp;
    }
    span2 = spanDefault;
    span3 = spanDefault;
  }

  void _sort2() {
    if (span2 != spanDown) {
      sortState = 2;
      devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
      span2 = spanDown;
    } else {
      sortState = 3;
      devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
      span2 = spanUp;
    }
    span1 = spanDefault;
    span3 = spanDefault;
  }

  void _sort3() {
    if (span3 != spanDown) {
      sortState = 4;
      devices.sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      span3 = spanDown;
    } else {
      sortState = 5;
      devices.sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      span3 = spanUp;
    }
    span2 = spanDefault;
    span1 = spanDefault;
  }

  void filterSearchResults(String query) {
    bool resultFound = false;
    var dummySearchList = [];
    dummySearchList.addAll(duplicateDevices);
    if (query.isNotEmpty) {
      var dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.id.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceName.toLowerCase().contains(query.toLowerCase()) ||
            item.deviceLocation.toLowerCase().contains(query.toLowerCase())) {
          resultFound = true;
          item.setHighLight(query);
          dummyListData.add(item);
        }
      });
      setState(() {
        validate = !resultFound;
        devices.clear();
        devices.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        validate = false;
        span1 = spanUp;
        span2 = spanDefault;
        span3 = spanDefault;
        devices.clear();
        devices.addAll(duplicateDevices);
        devices.forEach((item) => item.setHighLight(''));
      });
    }
  }

  @override
  void initState() {
    getLocations();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    deleteSnack = new Snack(this.context, "Deleting...", 100);
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
          child: ManageDevicesAppBar(context, "Manage Device", addDevice,
              exportPdf, advancedSearch, reset),
          preferredSize: const Size.fromHeight(50),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context, SizeRoute(page: AddClient()));
        //   },
        //   child: const Icon(Icons.add),
        //   backgroundColor: Color(0xff0065a3),
        // ),

        // drawer: SideDrawerAdmin(),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (text) {
                      filterSearchResults(text);
                    },
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
                      children: [
                        Container(
                          height: 30,
                          color: Colors.black12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort1();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'ID'),
                                          span1,
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort2();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Device Name'),
                                          span2,
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _sort3();
                                    });
                                  },
                                  child: MiddleLeft(Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(text: 'Location'),
                                          span3,
                                        ],
                                      ),
                                    ),
                                  )),
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
                            decoration: new BoxDecoration(color: Colors.white),
                            child: ListView.builder(
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.20,
                                  child: new Column(
                                    children: [
                                      Material(
                                        color: (index % 2 == 0)
                                            ? Colors.white
                                            : Color(0xf1f1f1f1),
                                        child: InkWell(
                                          onTap: () {
                                            AwesomeDialog(
                                              dialogBackgroundColor:
                                                  Color(0xfafafafa),
                                              context: context,
                                              animType: AnimType.SCALE,
                                              dialogType: DialogType.NO_HEADER,
                                              body: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    details('ID',
                                                        devices[index].id),
                                                    details(
                                                        'Device Name',
                                                        devices[index]
                                                            .deviceName),
                                                    details(
                                                        'Device Detail',
                                                        devices[index]
                                                            .deviceDetails),
                                                    details(
                                                        'Height',
                                                        devices[index]
                                                            .deviceHeight),
                                                    details(
                                                        'Activation Date',
                                                        devices[index]
                                                            .activationDate),
                                                    details(
                                                        'Location',
                                                        devices[index]
                                                            .deviceLocation),
                                                    details(
                                                        'Last Signal',
                                                        devices[index]
                                                            .lastSignal),
                                                    l123('L1#',
                                                        devices[index].l1),
                                                    l123('L2#',
                                                        devices[index].l2),
                                                    l123('L3#',
                                                        devices[index].l3),
                                                    battery('Battery',
                                                        devices[index].battery),
                                                    rssi('Rssi',
                                                        devices[index].rssi),
                                                    status('Status',
                                                        devices[index].status),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<
                                                            Color>((devices[index]
                                                                        .lat !=
                                                                    500 &&
                                                                devices[index]
                                                                        .lon !=
                                                                    500 &&
                                                                devices[index]
                                                                    .deviceName
                                                                    .isNotEmpty)
                                                            ? PrimaryColor
                                                            : Colors.grey),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black12),
                                                          ),
                                                        ),
                                                      ),

                                                      onPressed: () => (devices[
                                                                          index]
                                                                      .lat !=
                                                                  500 &&
                                                              devices[
                                                                          index]
                                                                      .lon !=
                                                                  500 &&
                                                              devices[
                                                                      index]
                                                                  .deviceName
                                                                  .isNotEmpty)
                                                          ? MapsLauncher
                                                              .launchCoordinates(
                                                                  devices[index]
                                                                      .lat,
                                                                  devices[index]
                                                                      .lon,
                                                                  devices[index]
                                                                      .deviceName)
                                                          : toast(
                                                              "Location is unavailable")
                                                      // if (lat != 500 && lon != 500 && title.isNotEmpty) {
                                                      //   MapsLauncher.launchCoordinates(lat, lon, title);
                                                      // }
                                                      ,
                                                      // tooltip: 'Google maps',
                                                      child: Center(
                                                        child: Container(
                                                          height: 30,
                                                          child: Row(
                                                            children: [
                                                              Spacer(),
                                                              Text(
                                                                "Show on google maps",
                                                                style: TextStyle(
                                                                    color: (devices[index].lat != 500 &&
                                                                            devices[index].lon !=
                                                                                500 &&
                                                                            devices[index]
                                                                                .deviceName
                                                                                .isNotEmpty)
                                                                        ? null
                                                                        : Colors
                                                                            .black54,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Image(
                                                                  color: (devices[index].lat != 500 &&
                                                                          devices[index].lon !=
                                                                              500 &&
                                                                          devices[index]
                                                                              .deviceName
                                                                              .isNotEmpty)
                                                                      ? null
                                                                      : Colors
                                                                          .black54,
                                                                  image: AssetImage(
                                                                      'assets/image/google_maps.png'),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              title: 'This is Ignored',
                                              desc: 'This is also Ignored',
                                            )..show();
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index].id,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    // Text(
                                                    //   ID,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index]
                                                          .deviceName,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   Details,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: SubstringHighlight(
                                                      text: devices[index]
                                                          .deviceLocation,
                                                      term: devices[index]
                                                          .highLight,
                                                      textStyleHighlight:
                                                          TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   Location,
                                                    //   textAlign: TextAlign.left,
                                                    //   style: TextStyle(fontSize: 12),
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    new IconSlideAction(
                                      caption: 'Logs',
                                      color: Color(0xffFFB61E),
                                      icon: Icons.signal_cellular_alt,
                                      onTap: () => toast('Logs'),
                                    ),
                                    new IconSlideAction(
                                      caption: 'Download',
                                      color: Colors.green,
                                      icon: Icons.download,
                                      onTap: () => toast('Downloading'),
                                    ),
                                  ],
                                  secondaryActions: <Widget>[
                                    new IconSlideAction(
                                      caption: 'Edit',
                                      color: Color(0xff62D0F1),
                                      icon: Icons.edit,
                                      onTap: () => editDevice(devices[index]),
                                    ),
                                    new IconSlideAction(
                                      caption: 'Delete',
                                      color: Color(0xffE5343D),
                                      icon: Icons.delete,
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Delete Device',
                                          desc:
                                              'Do you really want to delete ' +
                                                  devices[index].deviceName,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            deleteSnack.show();
                                            sendDeleteReq(devices[index].id);
                                          },
                                        )..show();
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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

  void editDevice(DeviceJason deviceJason) {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Edit Device", deviceJason),
      ),
    ).then((value) => getLocations());
  }

  void addDevice() {
    Navigator.push(
      context,
      SizeRoute(
        page: AddDevice("Add Device", null),
      ),
    ).then((value) => getLocations());
  }

  void exportPdf() {
    toast("Exporting...");
  }

  void advancedSearch() {
    Navigator.of(context).push(
      new MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return new Scaffold(
              backgroundColor: Color(0xfafafafa),
              appBar: new AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff0065a3),
                title: const Text('Advanced Search'),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.restart_alt,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      clientAd = "";
                      simProviderAd = "";
                      batchNumAd.text = "";
                      activationFromAd.text = "";
                      activationToAd.text = "";
                      lastSignalAd.text = "";
                      Navigator.pop(this.context);
                      getLocations();
                    },
                  )
                ],
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(15),
                    color: Color(0xfafafafa),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ModalFilter(clientAd, "Client", client,
                            (val) => clientAd = val, "", false),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Client Batch Number',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmartField(
                          controller: batchNumAd,
                          hintText: "Client Batch Number",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Activation Date From',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmartDate(
                          controller: activationFromAd,
                          hintText: "Activation Date From",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Activation Date To',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmartDate(
                          controller: activationToAd,
                          hintText: "Activation Date To",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Sim Provider',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ModalFilter(
                            simProviderAd,
                            "Sim Provider",
                            simCardProvider,
                            (val) => simProviderAd = val,
                            "",
                            false),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Last Signal From',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmartDate(
                          controller: lastSignalAd,
                          hintText: "Last Signal From",
                        ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (clientAd == "" &&
                      simProviderAd == "" &&
                      batchNumAd.text == "" &&
                      activationFromAd.text == "" &&
                      activationToAd.text == "" &&
                      lastSignalAd.text == "") {
                    toast("Please fill in any field to search");
                    return;
                  }
                  advancedSearchBool = true;
                  Navigator.pop(this.context);
                  getLocations();
                },
                child: const Icon(Icons.search),
                backgroundColor: Color(0xff0065a3),
              ),
            );
          },
          fullscreenDialog: true),
    );
  }

  void sendDeleteReq(String deviceId) {
    http.post(
        Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/deleteDevice.php'),
        body: {
          'device_id': deviceId,
        }).then((response) {
      if (response.statusCode == 200) {
        String body = json.decode(response.body);
        if (body == '0') {
          toast("Device has been deleted successfully");
          getLocations();
        } else {
          toast("Something wrong with the server");
          print(body);
        }
      } else {
        toast("Something wrong with the server");
        print(response.body);
      }
      deleteSnack.hide();
      getLocations();
    }).onError((error, stackTrace) {
      deleteSnack.hide();
      getLocations();
      toast('Error: ' + error.message);
    });
  }

  void getLocations() {
    setState(() {
      loading = true;
    });
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/getLocations.php'))
        .then((value) {
      List<String> id = [];
      List<String> locationName = [];
      if (value.statusCode == 200) {
        List<dynamic> values = [];
        values = json.decode(value.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              id.add(map['location_id'].toString());
              locationName.add(map['location_name'].toString());
            }
          }
        }
        getDevices(id, locationName);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get locations");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void getDevices(List<String> id, List<String> locationName) {
    http
        .get(Uri.parse(
            'http://103.18.247.174:8080/AmitProject/admin/getDevices.php'))
        .then((value) {
      if (value.statusCode == 200) {
        List<DeviceJason> devices = [];
        List<dynamic> values = [];
        values = json.decode(value.body);

        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              devices.add(DeviceJason.fromJson(
                  map,
                  locationName
                      .elementAt(id.indexOf(map['location_id'].toString()))));
            }
          }
        }
        showDevices(devices);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get device list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showDevices(List<DeviceJason> devices) {
    setState(() {
      this.duplicateDevices.clear();
      this.devices.clear();
      if (!advancedSearchBool) {
        // this.duplicateDevices.addAll(devices);
        this.devices.addAll(devices);
      } else {
        addFilteredClients(devices);
        advancedSearchBool = false;
      }
      if (sortState == 0) {
        this.devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      } else if (sortState == 1) {
        this.devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      } else if (sortState == 2) {
        this.devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
      } else if (sortState == 3) {
        this.devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
      } else if (sortState == 4) {
        this
            .devices
            .sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      } else if (sortState == 5) {
        this
            .devices
            .sort((a, b) => b.deviceLocation.compareTo(a.deviceLocation));
      }
      this.duplicateDevices.addAll(this.devices);
      loading = false;
    });
  }

  void addFilteredClients(List<DeviceJason> devices) {
    devices.forEach((device) {
      bool clientBool = (clientAd.isEmpty ||
          client[getInt(device.client) - 1].contains(clientAd));
      bool batchBool = (batchNumAd.text.isEmpty ||
          device.batchNum.toLowerCase().contains(batchNumAd.text.toString()));
      bool activationFromBool;
      try {
        activationFromBool = (activationFromAd.text.isEmpty ||
            DateFormat('dd-MM-yyyy').parse(device.activationDate).isAfter(
                DateFormat('dd-MM-yyyy').parse(activationFromAd.text))||DateFormat('dd-MM-yyyy').parse(device.activationDate).isAtSameMomentAs(
            DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
      } catch (Exception) {
        activationFromBool = false;
      }
      bool activationToBool;
      try {

        activationToBool = (activationToAd.text.isEmpty ||
          DateFormat('dd-MM-yyyy').parse(device.activationDate).isBefore(DateFormat('dd-MM-yyyy').parse(activationToAd.text))||  DateFormat('dd-MM-yyyy').parse(device.activationDate).isAtSameMomentAs(DateFormat('dd-MM-yyyy').parse(activationToAd.text)));

      } catch (Exception) {
        activationToBool = false;
      }
      bool simBool =
          (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));

      bool lastSignalBool;
      try {

        lastSignalBool = (lastSignalAd.text.isEmpty ||
            DateFormat('yyyy-MM-dd HH:mm:ss').parse(device.lastSignal).isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text))||  DateFormat('yyyy-MM-dd HH:mm:ss').parse(device.lastSignal).isAtSameMomentAs(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));

      } catch (Exception) {
        lastSignalBool = false;
      }

      if (clientBool &&
              batchBool &&
              activationFromBool &&
              activationToBool &&
              simBool&&
          lastSignalBool
          ) {
        this.devices.add(device);
      }
    });
  }

  void reset() {
    clientAd = "";
    simProviderAd = "";
    batchNumAd.text = "";
    activationFromAd.text = "";
    activationToAd.text = "";
    lastSignalAd.text = "";
    getLocations();
  }

  int getInt(String s) {
    try {
      if (s == null || int.parse(s) == null) {
        return 0;
      }
      return int.parse(s);
    } catch (Exception) {
      return 0;
    }
  }
}
