import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../public.dart';

class Loading extends StatelessWidget {
  final loading;
  final size;

  Loading({this.loading,this.size=55.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        child: SpinKitSquareCircle(//SpinKitCircle
          color: PrimaryColor,
          size: size,
        ),
        visible: loading,
      ),
    );
  }
}
