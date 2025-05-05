import 'package:flutter/material.dart';

class AppAnimations {
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration slowDuration = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeIn;
  static const Curve slowCurve = Curves.easeOut;

  static const double fadeOutOpacity = 0.0;
  static const double fadeInOpacity = 1.0;

  static Widget fadeTransition({
    required Widget child,
    required bool visible,
    Duration duration = defaultDuration,
    Curve curve = defaultCurve,
  }) {
    return AnimatedOpacity(
      opacity: visible ? fadeInOpacity : fadeOutOpacity,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget scaleTransition({
    required Widget child,
    required bool visible,
    Duration duration = defaultDuration,
    Curve curve = defaultCurve,
  }) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.8,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget slideTransition({
    required Widget child,
    required bool visible,
    Duration duration = defaultDuration,
    Curve curve = defaultCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: visible ? 0 : MediaQuery.of(context).size.width,
      child: child,
    );
  }

  static Widget iosSpringAnimation({
    required Widget child,
    required bool visible,
    double scale = 1.0,
  }) {
    return AnimatedScale(
      scale: visible ? scale : 0.95,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  static Widget webHoverAnimation({
    required Widget child,
    double scale = 1.05,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(scale),
        child: child,
      ),
    );
  }
}
