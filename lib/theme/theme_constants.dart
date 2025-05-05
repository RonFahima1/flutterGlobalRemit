import 'package:flutter/material.dart';

/// iOS-style text styles following SF Pro typography
abstract class GlobalRemitTypography {
  static const double largeTitleSize = 34.0;
  static const double title1Size = 28.0;
  static const double title2Size = 22.0;
  static const double title3Size = 20.0;
  static const double headlineSize = 17.0;
  static const double bodySize = 17.0;
  static const double calloutSize = 16.0;
  static const double subheadSize = 15.0;
  static const double footnoteSize = 13.0;
  static const double caption1Size = 12.0;
  static const double caption2Size = 11.0;

  static TextStyle largeTitle(BuildContext context) {
    return TextStyle(
      fontSize: largeTitleSize,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.41,
      height: 1.2,
    );
  }

  static TextStyle title1(BuildContext context) {
    return TextStyle(
      fontSize: title1Size,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.41,
      height: 1.2,
    );
  }

  static TextStyle title2(BuildContext context) {
    return TextStyle(
      fontSize: title2Size,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.41,
      height: 1.2,
    );
  }

  static TextStyle title3(BuildContext context) {
    return TextStyle(
      fontSize: title3Size,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
      height: 1.2,
    );
  }

  static TextStyle headline(BuildContext context) {
    return TextStyle(
      fontSize: headlineSize,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
  }

  static TextStyle body(BuildContext context) {
    return TextStyle(
      fontSize: bodySize,
      height: 1.2,
    );
  }

  static TextStyle callout(BuildContext context) {
    return TextStyle(
      fontSize: calloutSize,
      height: 1.2,
    );
  }

  static TextStyle subhead(BuildContext context) {
    return TextStyle(
      fontSize: subheadSize,
      height: 1.2,
    );
  }

  static TextStyle footnote(BuildContext context) {
    return TextStyle(
      fontSize: footnoteSize,
      height: 1.2,
    );
  }

  static TextStyle caption1(BuildContext context) {
    return TextStyle(
      fontSize: caption1Size,
      height: 1.2,
    );
  }

  static TextStyle caption2(BuildContext context) {
    return TextStyle(
      fontSize: caption2Size,
      height: 1.2,
    );
  }
}
