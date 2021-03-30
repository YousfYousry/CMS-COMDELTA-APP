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
          ],
        ),
      ),
    );
  }
}
