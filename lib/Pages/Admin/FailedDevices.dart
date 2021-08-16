import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login_cms_comdelta/JasonHolders/DeviceJason.dart';
import 'package:login_cms_comdelta/Widgets/AppBars/FailedDevicesAppBar.dart';
import 'package:login_cms_comdelta/Widgets/Others/Loading.dart';
import 'package:login_cms_comdelta/Widgets/Others/ShowDeviceDetails.dart';
import 'package:login_cms_comdelta/Widgets/Position/MiddleLeft.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartDate.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartSelect.dart';
import 'package:login_cms_comdelta/Widgets/SmartWidgets/smartTextField.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'dart:math' as math;

import '../../Choices.dart';

const PrimaryColor = const Color(0xff0065a3);

class FailedDevice extends StatefulWidget {
  @override
  _FailedDevice createState() => _FailedDevice();
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

class _FailedDevice extends State<FailedDevice> {
  TextEditingController searchController = new TextEditingController();
  bool loading = true, validate = false;
  String clientAd = "", simProviderAd = "";
  TextEditingController batchNumAd = new TextEditingController(),
      activationFromAd = new TextEditingController(),
      activationToAd = new TextEditingController(),
      lastSignalAd = new TextEditingController();
  bool advancedSearchBool = false;

  var span1 = spanUp, span2 = spanDefault, span3 = spanDefault;
  var devices = [];
  var duplicateDevices = [];
  int sortState = 1;

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
          child: FailedDevicesAppBar(context, "Failed Device", advancedSearch),
          preferredSize: const Size.fromHeight(50),
        ),
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
                                return Column(
                                  children: [
                                    Material(
                                      color: (index % 2 == 0)
                                          ? Colors.white
                                          : Color(0xf1f1f1f1),
                                      child: InkWell(
                                        onTap: () {
                                          ShowDevice(context, devices[index]);
                                        },
                                        child: Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
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
                                                  padding:
                                                      EdgeInsets.only(left: 10),
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
                                                  padding:
                                                      EdgeInsets.only(left: 10),
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
              child: Loading(
                loading: loading,
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
              DeviceJason device = DeviceJason.fromJson(
                  map,
                  locationName
                      .elementAt(id.indexOf(map['location_id'].toString())));
              if (device.inActiveLast72()) {
                devices.add(device);
              }
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
                DateFormat('dd-MM-yyyy').parse(activationFromAd.text)) ||
            DateFormat('dd-MM-yyyy')
                .parse(device.activationDate)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(activationFromAd.text)));
      } catch (Exception) {
        activationFromBool = false;
      }
      bool activationToBool;
      try {
        activationToBool = (activationToAd.text.isEmpty ||
            DateFormat('dd-MM-yyyy').parse(device.activationDate).isBefore(
                DateFormat('dd-MM-yyyy').parse(activationToAd.text)) ||
            DateFormat('dd-MM-yyyy')
                .parse(device.activationDate)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(activationToAd.text)));
      } catch (Exception) {
        activationToBool = false;
      }
      bool simBool =
          (simProviderAd.isEmpty || device.simProvider.contains(simProviderAd));

      bool lastSignalBool;
      try {
        lastSignalBool = (lastSignalAd.text.isEmpty ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAfter(DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)) ||
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .parse(device.lastSignal)
                .isAtSameMomentAs(
                    DateFormat('dd-MM-yyyy').parse(lastSignalAd.text)));
      } catch (Exception) {
        lastSignalBool = false;
      }

      if (clientBool &&
          batchBool &&
          activationFromBool &&
          activationToBool &&
          simBool &&
          lastSignalBool) {
        this.devices.add(device);
      }
    });
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 0;
    }
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

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }
}
