import 'package:flutter/material.dart';

class CustomScaleTransition extends PageRouteBuilder {
  final Widget page;
  final Alignment alignment;

  CustomScaleTransition(this.page, {required this.alignment})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
              reverseCurve: Curves.fastOutSlowIn,
            );
            return ScaleTransition(
              scale: animation,
              alignment: alignment,
              child: child,
            );
          },
        );
}
