import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/ActiveDeviceCard.dart';
import 'package:login_cms_comdelta/InactiveDeviceCard.dart';
import 'package:login_cms_comdelta/TotalDevicesCard.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/CustomAppBarWithBack.dart';
import 'Widgets/FloatingButtonDashBoard.dart';
import 'Widgets/ProgressBar.dart';
import 'Widgets/SideDrawer.dart';
import 'Widgets/SizeTransition.dart';
import 'package:http/http.dart' as http;

class DeviceStatus extends StatefulWidget {
  @override
  _DeviceStatus createState() => _DeviceStatus();
}

class _DeviceStatus extends State<DeviceStatus> {
  TextEditingController totalDevices = new TextEditingController(),
      activeDevices = new TextEditingController(),
      inactiveDevices = new TextEditingController();
  bool loading = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: CustomAppBarBack(context,"Device Status"),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingButton1(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TotalDeviceCard()));
                        },
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 60,
                                  height: 110,
                                  child: Image.asset('assets/image/track.jpg')),
                              Container(
                                width: 200,
                                height: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      totalDevices.text,
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text.rich(TextSpan(
                                        text: 'Total Devices',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // Total Devices
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, SizeRoute(page: ActiveDeviceCard()));
                        },
                        child: Container(
                          width: 320,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 60,
                                  height: 110,
                                  child: Image.asset('assets/image/active.png')),
                              Container(
                                width: 200,
                                height: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      activeDevices.text,
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text.rich(TextSpan(
                                        text: 'Total Active Devices',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // Active Devices Last 72 Hours

                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context, SizeRoute(page: InactiveDeviceCard()));
                        },
                        child: Container(
                          width: 320,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 60,
                                  height: 110,
                                  child: Image.asset('assets/image/inactive1.png')),
                              Container(
                                width: 200,
                                height: 110,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      inactiveDevices.text,
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text.rich(TextSpan(
                                        text: 'Total Inactive Devices',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // Inactive Devices Last 72 Hours
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Visibility(
              child: CircularProgressIndicatorApp(),
              visible: loading,
            ),
          ),
        ],
      )
    );
  }

  Future<void> getInfo() async {
    load('client_id').then((value) =>
    value != '-1' ? sendPost(value) : toast('User was not found!'));
  }

  void sendPost(String clientId) {
    http.post(
        Uri.parse('http://103.18.247.174:8080/AmitProject/getDeviceNumber.php'),
        body: {
          'client_id': clientId,
        }).then((response) {
      if (response.statusCode == 200) {
        // ignore: deprecated_member_use
        String value = json.decode(response.body);
        if (value != '-1') {
          List<String> result = value.split(',');
          if (result.length > 2) {
            setState(() {
              totalDevices.text = result[0];
              activeDevices.text = result[1];
              inactiveDevices.text = result[2];
            });
          } else {
            toast('Something wrong with the server!');
          }
        } else {
          toast('User does not exist');
        }

        setState(() {
          loading = false;
        });
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
  Future<String> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '-1';
  }
}
