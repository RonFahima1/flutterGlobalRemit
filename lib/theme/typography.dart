import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// GlobalRemit Typography - Following iOS Design Guidelines
/// This class implements the iOS typography styles based on SF Pro fonts
class GlobalRemitTypography {
  // Base text styles - matches SF Pro fonts
  static const String _fontFamily = '.SF Pro Text';
  static const String _displayFontFamily = '.SF Pro Display';

  // Base style method to reduce code duplication
  static TextStyle _baseStyle(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    required double letterSpacing,
    Color? color,
    String? fontFamily,
    TextDecoration? decoration,
    double? height,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: fontFamily ?? _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color ?? (isDark ? Colors.white : Colors.black),
      decoration: decoration,
      height: height,
    );
  }

  // Large Title: 34pt, SF Pro Display Bold
  static TextStyle largeTitle(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.37,
      color: color,
      fontFamily: _displayFontFamily,
    );
  }

  // Title 1: 28pt, SF Pro Display Bold
  static TextStyle title1(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.36,
      color: color,
      fontFamily: _displayFontFamily,
    );
  }

  // Title 2: 22pt, SF Pro Display Bold
  static TextStyle title2(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.35,
      color: color,
      fontFamily: _displayFontFamily,
    );
  }

  // Title 3: 20pt, SF Pro Display Semibold
  static TextStyle title3(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 20,
      fontWeight: FontWeight.w600, // semibold
      letterSpacing: 0.38,
      color: color,
      fontFamily: _displayFontFamily,
    );
  }

  // Headline: 17pt, SF Pro Text Semibold
  static TextStyle headline(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 17,
      fontWeight: FontWeight.w600, // semibold
      letterSpacing: -0.41,
      color: color,
    );
  }

  // Body: 17pt, SF Pro Text Regular
  static TextStyle body(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 17,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.41,
      color: color,
    );
  }

  // Callout: 16pt, SF Pro Text Regular
  static TextStyle callout(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.32,
      color: color,
    );
  }

  // Subhead: 15pt, SF Pro Text Regular
  static TextStyle subhead(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.24,
      color: color,
    );
  }

  // Footnote: 13pt, SF Pro Text Regular
  static TextStyle footnote(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 13,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.08,
      color: color,
    );
  }

  // Caption 1: 12pt, SF Pro Text Regular
  static TextStyle caption1(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      color: color,
    );
  }

  // Caption 2: 11pt, SF Pro Text Regular
  static TextStyle caption2(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 11,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.07,
      color: color,
    );
  }

  // Helper text styles for specific use cases
  static TextStyle bodySecondary(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color defaultColor = isDark ? Colors.white70 : Colors.black54;
    return _baseStyle(
      context,
      fontSize: 17,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.41,
      color: color ?? defaultColor,
    );
  }

  static TextStyle bodyBold(BuildContext context, {Color? color}) {
    return _baseStyle(
      context,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
      color: color,
    );
  }

  // CupertinoTheme text styles for consistent iOS styling
  static CupertinoTextThemeData cupertinoTextTheme(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color primaryColor = Colors.blue; // Replace with your app's primary color
    
    return CupertinoTextThemeData(
      primaryColor: primaryColor,
      textStyle: body(context, color: textColor),
      actionTextStyle: bodyBold(context, color: primaryColor),
      tabLabelTextStyle: _baseStyle(
        context,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.24,
        color: textColor,
      ),
      navActionTextStyle: _baseStyle(
        context,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        color: primaryColor,
      ),
      navLargeTitleTextStyle: largeTitle(context, color: textColor),
      navTitleTextStyle: headline(context, color: textColor),
    );
  }
}

// Extension for semantic font weight naming
extension FontWeightExtension on FontWeight {
  static const FontWeight semiBold = FontWeight.w600;
}
