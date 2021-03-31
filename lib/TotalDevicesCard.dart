import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/DataTableInfo.dart';
import 'package:login_cms_comdelta/Widgets/DropDwonListValue.dart';

import 'Widgets/MyAppBar.dart';
import 'Widgets/SideDrawer.dart';
import 'Widgets/DeviceListHeader.dart';
import 'Widgets/FloatingActionButton.dart';
import 'Widgets/DropDwonListValue.dart';
import 'Widgets/CustomizeTextField.dart';

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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Show',
                                style: TextStyle(fontSize: 16),
                              ),
                              DropDownListValue(),
                              Text('Enteries')
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Search',
                                style: TextStyle(fontSize: 16),
                              ),
                              CustomizeTextField(),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        DataTableInfo(),
                      ],
                    ),
                  ),
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
