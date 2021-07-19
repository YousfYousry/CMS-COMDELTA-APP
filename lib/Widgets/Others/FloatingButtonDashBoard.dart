import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
