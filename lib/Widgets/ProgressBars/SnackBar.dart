import 'package:flutter/material.dart';

class Snack {
  var _snackBar;
  final BuildContext context;

  Snack(this.context, String title,int seconds) {
    _snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: seconds),
    );
  }

  void show() => ScaffoldMessenger.of(context).showSnackBar(_snackBar);

  void hide() => ScaffoldMessenger.of(context).hideCurrentSnackBar();
}
