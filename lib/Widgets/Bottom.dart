import 'package:flutter/cupertino.dart';
class bottom extends StatelessWidget {
  Widget widget;

  bottom(this.widget);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        // Align(alignment: Alignment.centerRight, child: Text("123")),
        widget,
      ],
    );
  }
}