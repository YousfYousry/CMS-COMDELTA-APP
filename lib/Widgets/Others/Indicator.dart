import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:login_cms_comdelta/Pages/Admin/AdminDashBoard.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Indicator extends StatelessWidget {

  final radius,value0,value1,value2;

  const Indicator(
      {Key key,
        this.radius,
        this.value0,
        this.value1,
        this.value2,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius - 80,
      animation: true,
      animationDuration: 2000,
      lineWidth: 20.0,
      percent: value0/ value2,
      center: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Countup(
            begin: 0,
            end: value0,
            duration: Duration(seconds: 2),
            separator: ',',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: PrimaryColor),
          ),
          Countup(
            begin: value2,
            end: value1,
            duration: Duration(seconds: 2),
            separator: ',',
            style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          Spacer(),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      backgroundColor: Colors.grey,
      progressColor: PrimaryColor,
    );
  }
}