import 'package:flutter/material.dart';

class NavigatorUtils {
  static void goTo(BuildContext context, { required dynamic page }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            //opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  static void gotoWithoutReturn(BuildContext context, { required dynamic page }) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }
}