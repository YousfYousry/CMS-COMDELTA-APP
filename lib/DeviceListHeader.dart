import 'package:flutter/material.dart';

class DeviceListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            color: Colors.white,
            height: 60,
            width: 60,
            child: Image.asset('assets/image/list2.png'),
          ), //Container for Dashboard icon
          Container(
            color: Colors.white,
            height: 100,
            width: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Device List Manager',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.important_devices),
                      ),
                      TextSpan(
                        text: '  Manage your devices',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), // Container for DashBoard Header and textspan
        ],
      ),
    );
  }
}
