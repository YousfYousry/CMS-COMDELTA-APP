import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBarBack extends StatelessWidget {
  String title = '';
  BuildContext context;
  CustomAppBarBack(this.context,this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(this.context),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
