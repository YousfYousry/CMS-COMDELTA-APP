import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.red,
      strokeWidth: 8,);
  }
}