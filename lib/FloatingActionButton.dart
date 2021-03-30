import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './DeviceStatus.dart';

class FloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DeviceStatus()));
      },
      label: const Text('Back'),
      icon: Icon(Icons.arrow_back),
      backgroundColor: Color(0xff0065a3),
    );
  }
}
