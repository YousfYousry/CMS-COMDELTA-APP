import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class SizeRoute extends PageTransition { //PageRouteBuilder
  final Widget page;
  SizeRoute({this.page})
      : super(
    child: page,
    type: PageTransitionType.fade,

    // settings: settings,
    // reverseDuration: Duration(seconds: 3),
    // inheritTheme: true,
    // pageBuilder: (context, animation, secondaryAnimation) => page,
    // transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //   const begin = Offset(0.0, 1.0);
    //   const end = Offset.zero;
    //   const curve = Curves.ease;
    //
    //   var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //
    //   return SlideTransition(
    //     position: animation.drive(tween),
    //     child: child,
    //   );
    // },
    //       pageBuilder:   (
    //         BuildContext context,
    //         Animation<double> animation,
    //         Animation<double> secondaryAnimation,
    //       ) =>
    //           page
    //
    // ,
    //       transitionsBuilder:
    //
    //           (
    //         BuildContext context,
    //         Animation<double> animation,
    //         Animation<double> secondaryAnimation,
    //         Widget child,
    //       ) =>
    //           Align(
    //             child: SizeTransition(
    //               sizeFactor: animation,
    //               child: child,
    //             ),
    //           ),
        );
}