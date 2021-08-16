import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_cms_comdelta/Pages/Client/ActiveDeviceCard.dart';

class Loading extends StatelessWidget {
  final loading;

  Loading({this.loading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        child: SpinKitCircle(
          color: PrimaryColor,
          size: 55,
        ),
        visible: loading,
      ),
    );
  }
}
