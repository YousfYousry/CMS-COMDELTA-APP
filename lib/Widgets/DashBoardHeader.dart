import 'package:flutter/material.dart';

class DashBoardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: double.infinity,
      height: 120,
      color: Colors.transparent,
      child: Image.asset(
        "assets/image/DesignLogo.png",
        fit: BoxFit.contain,
        height: 120,
      ),
    );
  }
}
