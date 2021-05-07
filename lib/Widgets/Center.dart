import 'package:flutter/cupertino.dart';
// ignore: must_be_immutable, camel_case_types
class center extends StatelessWidget {
  Widget widget;

  center(this.widget);

  @override
  Widget build(BuildContext context) {
    return
        Column(
          children: <Widget>[
            Spacer(),
            widget,
            Spacer(),
          ],
        );
  }
}