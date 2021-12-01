import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_cms_comdelta/Pages/Client/ActiveDeviceCard.dart';

class Loading extends StatelessWidget {
  final loading;
  final color;
  final size;

  Loading({this.loading, this.color=PrimaryColor,this.size=55.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        child: SpinKitSquareCircle(//SpinKitCircle
          color: color,
          size: size,
        ),
        visible: loading,
      ),
    );
  }
}
