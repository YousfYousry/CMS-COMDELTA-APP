import 'package:flutter/material.dart';
import './SideDrawer.dart';
import './MyAppBar.dart';
import './DashBoardHeader.dart';

class DeviceStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: PreferredSize(
          child: MyAppBar1(),
          preferredSize: const Size.fromHeight(50),
        ),
        drawer: SideDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            DashBoardHeader(),
            SizedBox(height: 30),
            Container(
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
                          child: Image.asset('assets/image/status.png')),
                      Container(
                          width: 200,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '229',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              Text.rich(TextSpan(
                                  text: 'Total Devices',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))
                            ],
                          ))
                  
                    ])), // Total Devices

            Container(), // Active Devices Last 72 Hours

            Container(), // Inactive Devices Last 72 Hours
          ]),
        ));
  }
}
