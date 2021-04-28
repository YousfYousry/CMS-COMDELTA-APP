import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login_cms_comdelta/ActiveDeviceCard.dart';
import 'package:login_cms_comdelta/Classes/device.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/InactiveDeviceCard.dart';
import 'package:login_cms_comdelta/TotalDevicesCard.dart';
import 'package:login_cms_comdelta/Widgets/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:login_cms_comdelta/Widgets/ProgressBar.dart';
import 'package:login_cms_comdelta/Widgets/SideDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PrimaryColor = const Color(0xff0065a3);

class DashBoardNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS Login UI',
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: DashBoardPage(title: 'CMS Dashboard'),
    );
  }
}

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  final LatLng _center = const LatLng(2.944590144570856, 101.60274569735296);
  bool loading = true;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getDevices();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width - 40;
    var numStyle=TextStyle(fontWeight: FontWeight.bold),titleStyle =TextStyle(fontSize: 12);
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: CustomAppBar("DashBoard"),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(), // sidebar
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 4,
            ),
            markers: Set<Marker>.of(markers.values), // YOUR
          ),
          Center(
            child: Visibility(
              child: CircularProgressIndicatorApp(),
              visible: loading,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/TotalDeviceCard');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TotalDeviceCard()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      height: 45,
                      width: width / 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 1))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '229',
                            style: numStyle,
                          ),
                          Text(
                            'Total Devices',
                            style: titleStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveDeviceCard()),);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      height: 45,
                      width: width / 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 1))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '190',
                            style: numStyle,
                          ),
                          Text(
                            'Active Devices',
                            style: titleStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InactiveDeviceCard()),);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      height: 45,
                      width: width / 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: Offset(0, 1))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10',
                            style: numStyle,
                          ),
                          Text(
                            'Inactive Devices',
                            style: titleStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Row(
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         Navigator.push(context, SizeRoute(page: DeviceStatus()));
          //       },
          //       child: Padding(
          //         padding: EdgeInsets.all(10),
          //         child: Container(
          //           width: double.infinity,
          //           height: 40,
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(3),
          //             boxShadow: [
          //               BoxShadow(
          //                   color: Colors.grey.withOpacity(0.5),
          //                   spreadRadius: 3,
          //                   blurRadius: 4,
          //                   offset: Offset(0, 1))
          //             ],
          //           ),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 '229',
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //               Text(
          //                 'Total Devices',
          //                 // style: TextStyle(fontWeight: FontWeight.bold),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ), //Container for Device Status
          //
          //     // SizedBox(height: 30),
          //     // InkWell(
          //     //   onTap: () {
          //     //     Navigator.push(
          //     //       context,
          //     //       SizeRoute(
          //     //         page: GoogleMapApp(),
          //     //       ),
          //     //     );
          //     //   },
          //     //   child: Container(
          //     //     width: 320,
          //     //     height: 130,
          //     //     decoration: BoxDecoration(
          //     //       color: Colors.white,
          //     //       borderRadius: BorderRadius.circular(10),
          //     //       boxShadow: [
          //     //         BoxShadow(
          //     //             color: Colors.grey.withOpacity(0.5),
          //     //             spreadRadius: 5,
          //     //             blurRadius: 7,
          //     //             offset: Offset(0, 3))
          //     //       ],
          //     //     ),
          //     //     child: Row(
          //     //       mainAxisAlignment: MainAxisAlignment.center,
          //     //       children: [
          //     //         Container(
          //     //           width: 80,
          //     //           height: 110,
          //     //           child: Image.asset('assets/image/maps.png'),
          //     //         ),
          //     //         Container(
          //     //           width: 200,
          //     //           height: 110,
          //     //           child: Column(
          //     //             mainAxisAlignment: MainAxisAlignment.center,
          //     //             children: [
          //     //               Text('Map',
          //     //                   style: TextStyle(
          //     //                       fontSize: 26, fontWeight: FontWeight.bold)),
          //     //               Text.rich(
          //     //                 TextSpan(
          //     //                   children: [
          //     //                     TextSpan(
          //     //                         text: 'Location of the Devices',
          //     //                         style: TextStyle(
          //     //                             fontWeight: FontWeight.bold))
          //     //                   ],
          //     //                 ),
          //     //               ),
          //     //             ],
          //     //           ),
          //     //         ),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ), //Container for Map
          //   ],
          // ),
        ],
      ),
    );
  }

  Future<void> getDevices() async {
    load('client_id').then((value) =>
    value != '-1' ? sendPost(value) : toast('User was not found!'));
  }

  void sendPost(String clientId) {
    http.post(Uri.parse('http://103.18.247.174:8080/AmitProject/getDevice.php'),
        body: {
          'client_id': clientId,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        List<Device> devices = new List<Device>();
        // ignore: deprecated_member_use
        List<dynamic> values = new List<dynamic>();
        values = json.decode(response.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              devices.add(Device.fromJson(map));
            }
          }
        }
        showDevices(devices);
      } else {
        setState(() {
          loading = false;
        });
        throw Exception("Unable to get devices list");
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      toast('Error: ' + error.message);
    });
  }

  void showDevices(List<Device> devices) {
    // ignore: deprecated_member_use
    List<LatLng> positions = new List<LatLng>();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)), 'assets/image/marker.png')
        .then((customIcon) {
      setState(() {
        for (Device device in devices) {
          if (getDouble(device.getLong()) != 0 &&
              getDouble(device.getLat()) != 0) {
            positions.add(new LatLng(
                getDouble(device.getLong()), getDouble(device.getLat())));
            markers[MarkerId(device.getName())] = Marker(
              anchor: const Offset(0.5, 0.5),
              markerId: MarkerId(device.getName()),
              position: LatLng(
                  getDouble(device.getLong()), getDouble(device.getLat())),
              infoWindow: InfoWindow(
                title: 'Site name: ' + device.getDeviceDetail(),
              ),
              icon: customIcon,
              draggable: false,
              zIndex: 1,
            );
          }
        }
        mapController.animateCamera(
            CameraUpdate.newLatLngBounds(_bounds(positions), 20));
        loading = false;
      });
    });
  }

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

  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '-1';
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1);
  }

  double getDouble(String str) {
    try {
      return double.parse(str);
    } catch (e) {
      return 0;
    }
  }
}
