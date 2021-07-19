import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Widgets/Position/Center.dart';

// ignore: must_be_immutable
class DashboardAppBar extends StatelessWidget {
  String title = '';

  DashboardAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      leading: Padding(
        padding: EdgeInsets.only(top: 17),
        child:IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      // centerTitle: true,
      flexibleSpace: ClipRRect(
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(50),
        //     bottomRight: Radius.circular(50)),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 60, right: 60),
            child: center(Image.asset('assets/image/logo2.png')),
          ),
        ),
      ),
      // title: Text(
      //   'DashBoard',
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      // ),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(30),
      //         bottomRight: Radius.circular(30))),
    );
  }
}
