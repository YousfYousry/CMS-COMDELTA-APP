import 'package:flutter/material.dart';

import './MyAppBar.dart';
import './SideDrawer.dart';
import './DeviceListHeader.dart';
import './FloatingActionButton.dart';

class TotalDeviceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: MyAppBar1(),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DeviceListHeader(),
            SizedBox(height: 30),
            Container(
              color: Colors.white,
              width: 340,
              height: 800,
              child: Column(
                children: [
                  Center(
                    heightFactor: 2,
                    child: Text(
                      'Total Devices',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    width: 320,
                    height: 700,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                        ]),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
