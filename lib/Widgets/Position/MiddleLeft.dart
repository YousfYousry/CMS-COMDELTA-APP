import 'package:flutter/cupertino.dart';
// ignore: must_be_immutable, camel_case_types
class MiddleLeft extends StatelessWidget {
  Widget widget;

  MiddleLeft(this.widget);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        Spacer(),
        Row(
          children: <Widget>[
            widget,
            Spacer(),
          ],
        ),
        Spacer(),
      ],
    );
  }
}