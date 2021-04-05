import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget {
  String title = '';

  CustomeAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
