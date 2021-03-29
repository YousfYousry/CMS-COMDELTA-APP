import 'package:flutter/material.dart';

class MyAppBar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Row(children: [
          Image.asset(
            "assets/image/logo.png",
            fit: BoxFit.contain,
            height: 120,
          ),
          SizedBox(width: 4),
        ]));
  }
}
