import 'package:flutter/material.dart';

class Navigate {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed<T extends Object?>(Widget child) {
    return navigatorKey.currentState!.push(pageRouteBuilder(child));
  }

  static Future<dynamic> pushAndReplace<T extends Object?, TO extends Object?>(
      Widget child) {
    return navigatorKey.currentState!.pushReplacement(pageRouteBuilder(child));
  }

  ///we use this method to push and replace with current page.
  static Future<dynamic> pushAndRemoveUntil<T extends Object?>(Widget child) {
    return navigatorKey.currentState!
        .pushAndRemoveUntil(pageRouteBuilder(child), (_) => false);
  }

  ///
  static pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  ///This is our page route Builder with animation
  static PageRouteBuilder pageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return leftToRight(context, animation, secondaryAnimation, child);
      },
    );
  }

  ///Animation method to left to right
  static SlideTransition leftToRight(
      context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutSine;
    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}
