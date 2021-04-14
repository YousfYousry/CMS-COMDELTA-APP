import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBarBack extends StatelessWidget {
  String title = '';
  BuildContext con;
  CustomAppBarBack(this.con,this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(con,false),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
