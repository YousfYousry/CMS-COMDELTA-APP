import 'package:flutter/cupertino.dart';
// ignore: must_be_immutable, camel_case_types
class bottom extends StatelessWidget {
  Widget widget;

  bottom(this.widget);

  @override
  Widget build(BuildContext context) {
    return
        Column(
          children: <Widget>[
            Spacer(),
            widget,
          ],
        );
  }
}