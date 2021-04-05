import 'package:flutter/material.dart';

class CustomizeTextField1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
      ),
    );
  }
}
