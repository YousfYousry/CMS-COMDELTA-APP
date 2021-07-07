import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_cms_comdelta/Client/DashBoard.dart';
import '../Client/DashBoard.dart';
import './SizeTransition.dart';

class FloatingButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
                Navigator.pop(context);
      },
      label: const Text('Back'),
      icon: Icon(Icons.arrow_back),
      backgroundColor: Color(0xff0065a3),
    );
  }
}
