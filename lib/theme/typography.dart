import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// GlobalRemit Typography - Following iOS Design Guidelines
/// This class implements the iOS typography styles based on SF Pro fonts
class GlobalRemitTypography {
  // Base text styles - matches SF Pro fonts
  static const String _fontFamily = '.SF Pro Text';
  static const String _displayFontFamily = '.SF Pro Display';

  // Large Title: 34pt, SF Pro Display Bold
  static TextStyle largeTitle(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.37,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Title 1: 28pt, SF Pro Display Bold
  static TextStyle title1(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.36,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Title 2: 22pt, SF Pro Display Bold
  static TextStyle title2(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.35,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Title 3: 20pt, SF Pro Display Semibold
  static TextStyle title3(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600, // semibold
      letterSpacing: 0.38,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Headline: 17pt, SF Pro Text Semibold
  static TextStyle headline(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w600, // semibold
      letterSpacing: -0.41,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Body: 17pt, SF Pro Text Regular
  static TextStyle body(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.41,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Callout: 16pt, SF Pro Text Regular
  static TextStyle callout(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.32,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Subhead: 15pt, SF Pro Text Regular
  static TextStyle subhead(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.24,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Footnote: 13pt, SF Pro Text Regular
  static TextStyle footnote(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.08,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Caption 1: 12pt, SF Pro Text Regular
  static TextStyle caption1(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Caption 2: 11pt, SF Pro Text Regular
  static TextStyle caption2(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.07,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // Helper text styles for specific use cases
  static TextStyle bodySecondary(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color defaultColor = isDark ? Colors.white70 : Colors.black54;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.41,
      color: color ?? defaultColor,
    );
  }

  static TextStyle bodyBold(BuildContext context, {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.41,
      color: color ?? (isDark ? Colors.white : Colors.black),
    );
  }

  // CupertinoTheme text styles for consistent iOS styling
  static CupertinoTextThemeData cupertinoTextTheme(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color primaryColor = Colors.blue; // Replace with your app's primary color
    
    return CupertinoTextThemeData(
      primaryColor: primaryColor,
      textStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.41,
        color: textColor,
      ),
      actionTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        color: primaryColor,
      ),
      tabLabelTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.24,
        color: textColor,
      ),
      navActionTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        color: primaryColor,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.37,
        color: textColor,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        color: textColor,
      ),
    );
  }
}
