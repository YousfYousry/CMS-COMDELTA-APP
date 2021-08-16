import 'package:flutter/material.dart';

class DeviceLogsAppBar extends StatelessWidget {
  final title;
  final context;
  final func1;

  DeviceLogsAppBar(this.context, this.title, this.func1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0065a3),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(this.context),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: func1,
        ),
      ],
    );
  }
}
