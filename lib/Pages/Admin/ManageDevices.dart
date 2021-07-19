import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/CustomAppBarWithBack.dart';
import 'package:login_cms_comdelta/Widgets/ProgressBars/ProgressBar.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'dart:math' as math;

// const PrimaryColor = const Color(0xff0065a3);

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

class _ManageDevice extends State<ManageDevice> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;

  var span1 = spanDown, span2 = spanDefault, span3 = spanDefault;
  var devices = [];
  var duplicateDevices = [];

  void _sort1() {
    if (span1 != spanDown) {
      devices.sort((a, b) => getDouble(a.id).compareTo(getDouble(b.id)));
      span1 = spanDown;
    } else {
      devices.sort((a, b) => getDouble(b.id).compareTo(getDouble(a.id)));
      span1 = spanUp;
    }
    span2 = spanDefault;
    span3 = spanDefault;
  }

  void _sort2() {
    if (span2 != spanDown) {
      devices.sort((a, b) => a.deviceName.compareTo(b.deviceName));
      span2 = spanDown;
    } else {
      devices.sort((a, b) => b.deviceName.compareTo(a.deviceName));
      span2 = spanUp;
    }
    span1 = spanDefault;
    span3 = spanDefault;
  }

  void _sort3() {
    if (span3 != spanDown) {
      devices.sort((a, b) => a.deviceLocation.compareTo(b.deviceLocation));
      span3 = spanDown;
    } else {
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
        span1 = spanDown;
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
    super.initState();
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
          child: CustomAppBarBack(context, "Manage Device"),
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
                          Radius.circular(0),
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
                            children: [
                              Expanded(
                                flex: 1,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort1();
                                    });
                                  },
                                  child: Padding(
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
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 4,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort2();
                                    });
                                  },
                                  child: Padding(
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
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 2,
                                child: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _sort3();
                                    });
                                  },
                                  child: Padding(
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
                                              context: context,
                                              animType: AnimType.SCALE,
                                              dialogType: DialogType.NO_HEADER,
                                              body: Center(child: Text(
                                                'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
                                                style: TextStyle(fontStyle: FontStyle.italic),
                                              ),),
                                              title: 'This is Ignored',
                                              desc:   'This is also Ignored',
                                              btnOkOnPress: () {},
                                            )..show();

                                            // AwesomeDialog(
                                            //   context: context,
                                            //   dialogType: DialogType.INFO,
                                            //   animType: AnimType.BOTTOMSLIDE,
                                            //   title: 'Delete Device',
                                            //   desc:
                                            //   'Do you really want to delete ' +
                                            //       devices[index].deviceName,
                                            //   btnCancelOnPress: () {},
                                            //   btnOkOnPress: () {},
                                            // )..show();
                                            // toast('tapped');
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
                                      onTap: () => toast('Edit'),
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
                                          btnOkOnPress: () {},
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

  void getLocations() {
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
            'http://103.18.247.174:8080/AmitProject/admin/getDevices.php')) //device_id  device_code	device_name	device_detail	device_longitud	device_latitud	location_id	client_id	status	CreatedBy	CreatedDate	ModifiedBy	ModifiedDate	LS1	LID1	LS2	LID2	LS3	LID3	LatestUpdateDate	LastUpdateDate	device_height	device_activation	site_region	client_batch_number	sim_serial_number	sim_provider	battery_status	rssi_status	LatestClient1Date	LatestClient2Date	LatestClient3Date	battery_value	rssi_value
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

  void showDevices(List<DeviceJason> clients) {
    setState(() {
      this.duplicateDevices.addAll(clients);
      this.devices.addAll(clients);
      loading = false;
    });
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 0;
    }
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}
