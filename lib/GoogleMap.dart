import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/MyAppBar.dart';
import 'package:login_cms_comdelta/SideDrawer.dart';

import './DashBoardHeader.dart';

class GoogleMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: PreferredSize(
        child: MyAppBar1(),
        preferredSize: const Size.fromHeight(50),
      ),
      drawer: SideDrawer(),
      body: Column(
        children: [
          DashBoardHeader(),
        ],
      ),
    );
  }
}
