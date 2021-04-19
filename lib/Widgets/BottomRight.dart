import 'package:flutter/cupertino.dart';
// ignore: must_be_immutable, camel_case_types
class bottomRight extends StatelessWidget {
  Widget widget;

  bottomRight(this.widget);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        Spacer(),
        Column(
          children: <Widget>[
            Spacer(),
            widget,
          ],
        ),
      ],
    );
  }
}