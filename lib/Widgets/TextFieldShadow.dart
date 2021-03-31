import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Visibility(
        child: TextField(
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: false,
      ),
      elevation: 5.0,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(32.0),
    );
  }
}