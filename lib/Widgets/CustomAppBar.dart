import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  String title = '';

  CustomAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
       textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
