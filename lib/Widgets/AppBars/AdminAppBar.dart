import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget with PreferredSizeWidget {

  AdminAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF0065a3),
      centerTitle: true,
      title:Container(
        height: 30,
        child: Image.asset('assets/image/onlycomdelta.png'),
      ),
      elevation: 10,
      // shape: ContinuousRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),

      // flexibleSpace: ClipRRect(
      //   // borderRadius: BorderRadius.only(
      //   //     bottomLeft: Radius.circular(50),
      //   //     bottomRight: Radius.circular(50)),
      //   child: Container(
      //     height: double.infinity,
      //     // decoration: BoxDecoration(
      //     //   image: DecorationImage(
      //     //     image: AssetImage("assets/image/background.jpg"),
      //     //     fit: BoxFit.cover,
      //     //   ),
      //     // ),
      //     child: Container(
      //       color: Color(0xff0065a3),//Color(0xd90065a3)
      //       child: Align(
      //         alignment: Alignment.bottomCenter,
      //         child: Container(
      //           height: 60,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 90, right: 90,top: 10,bottom: 10),
      //             child: Image.asset('assets/image/onlycomdelta.png'),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
