import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget {
  String title = '';

  CustomeAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
