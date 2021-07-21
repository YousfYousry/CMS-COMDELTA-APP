import 'package:flutter/cupertino.dart';
// ignore: must_be_immutable, camel_case_types
class Top extends StatelessWidget {
  Widget widget;

  Top(this.widget);

  @override
  Widget build(BuildContext context) {
    return
        Column(
          children: <Widget>[
            widget,
            Spacer(),
          ],
        );
  }
}