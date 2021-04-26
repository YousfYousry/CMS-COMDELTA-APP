import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBarBack extends StatelessWidget {
  String title = '';
  CustomAppBarBack(this.title,this.route);
  var route;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () =>
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => route)),
        }),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
