import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/ActiveDeviceCard.dart';
import 'package:login_cms_comdelta/InactiveDeviceCard.dart';
import 'package:login_cms_comdelta/TotalDevicesCard.dart';
import 'package:login_cms_comdelta/Widgets/CustomeAppBar.dart';
import 'Widgets/FloatingButtonDashBoard.dart';
import 'Widgets/SideDrawer.dart';
import 'Widgets/SizeTransition.dart';

class DeviceStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: CustomeAppBar('Device Status'),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingButton1(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context, SizeRoute(page: TotalDeviceCard()));
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
                                  '229',
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
                      Navigator.push(
                          context, SizeRoute(page: ActiveDeviceCard()));
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
                                  '190',
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
                                  '10',
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
    );
  }
}
