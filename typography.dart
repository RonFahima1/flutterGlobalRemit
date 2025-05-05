import 'package:flutter/material.dart';

/// Typography constants for the Global Remit iOS-style design system
class GlobalRemitTypography {
  /// Private constructor to prevent instantiation
  GlobalRemitTypography._();
  
  /// Font family that resembles SF Pro
  static const String fontFamily = '.SF Pro Text';
  static const String displayFontFamily = '.SF Pro Display';
  
  /// Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  /// Font sizes
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
  
  /// Letter spacing
  static const double largeTitleSpacing = 0.37;
  static const double title1Spacing = 0.36;
  static const double title2Spacing = 0.35;
  static const double title3Spacing = 0.38;
  static const double headlineSpacing = -0.41;
  static const double bodySpacing = -0.41;
  static const double calloutSpacing = -0.32;
  static const double subheadSpacing = -0.24;
  static const double footnoteSpacing = -0.08;
  static const double caption1Spacing = 0.0;
  static const double caption2Spacing = 0.07;
  
  /// Creates a TextStyle for large title text
  /// 34pt, SF Pro Display Bold
  static TextStyle largeTitle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: displayFontFamily,
      fontSize: largeTitleSize,
      fontWeight: bold,
      letterSpacing: largeTitleSpacing,
      color: color ?? Theme.of(context).textTheme.displayLarge?.color,
    );
  }
  
  /// Creates a TextStyle for title 1 text
  /// 28pt, SF Pro Display Bold
  static TextStyle title1(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: displayFontFamily,
      fontSize: title1Size,
      fontWeight: bold,
      letterSpacing: title1Spacing,
      color: color ?? Theme.of(context).textTheme.displayMedium?.color,
    );
  }
  
  /// Creates a TextStyle for title 2 text
  /// 22pt, SF Pro Display Bold
  static TextStyle title2(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: displayFontFamily,
      fontSize: title2Size,
      fontWeight: bold,
      letterSpacing: title2Spacing,
      color: color ?? Theme.of(context).textTheme.displaySmall?.color,
    );
  }
  
  /// Creates a TextStyle for title 3 text
  /// 20pt, SF Pro Display Semibold
  static TextStyle title3(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: displayFontFamily,
      fontSize: title3Size,
      fontWeight: semibold,
      letterSpacing: title3Spacing,
      color: color ?? Theme.of(context).textTheme.headlineLarge?.color,
    );
  }
  
  /// Creates a TextStyle for headline text
  /// 17pt, SF Pro Text Semibold
  static TextStyle headline(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: headlineSize,
      fontWeight: semibold,
      letterSpacing: headlineSpacing,
      color: color ?? Theme.of(context).textTheme.headlineMedium?.color,
    );
  }
  
  /// Creates a TextStyle for body text
  /// 17pt, SF Pro Text Regular
  static TextStyle body(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: bodySize,
      fontWeight: regular,
      letterSpacing: bodySpacing,
      color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }
  
  /// Creates a TextStyle for callout text
  /// 16pt, SF Pro Text Regular
  static TextStyle callout(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: calloutSize,
      fontWeight: regular,
      letterSpacing: calloutSpacing,
      color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
    );
  }
  
  /// Creates a TextStyle for subhead text
  /// 15pt, SF Pro Text Regular
  static TextStyle subhead(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: subheadSize,
      fontWeight: regular,
      letterSpacing: subheadSpacing,
      color: color ?? Theme.of(context).textTheme.bodySmall?.color,
    );
  }
  
  /// Creates a TextStyle for footnote text
  /// 13pt, SF Pro Text Regular
  static TextStyle footnote(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: footnoteSize,
      fontWeight: regular,
      letterSpacing: footnoteSpacing,
      color: color ?? Theme.of(context).textTheme.labelLarge?.color,
    );
  }
  
  /// Creates a TextStyle for caption 1 text
  /// 12pt, SF Pro Text Regular
  static TextStyle caption1(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: caption1Size,
      fontWeight: regular,
      letterSpacing: caption1Spacing,
      color: color ?? Theme.of(context).textTheme.labelMedium?.color,
    );
  }
  
  /// Creates a TextStyle for caption 2 text
  /// 11pt, SF Pro Text Regular
  static TextStyle caption2(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: caption2Size,
      fontWeight: regular,
      letterSpacing: caption2Spacing,
      color: color ?? Theme.of(context).textTheme.labelSmall?.color,
    );
  }
}

/// Extension to easily access typography styles from context
extension GlobalRemitTypographyExtension on BuildContext {
  /// Large Title: 34pt, SF Pro Display Bold
  TextStyle get largeTitle => GlobalRemitTypography.largeTitle(this);
  
  /// Title 1: 28pt, SF Pro Display Bold
  TextStyle get title1 => GlobalRemitTypography.title1(this);
  
  /// Title 2: 22pt, SF Pro Display Bold
  TextStyle get title2 => GlobalRemitTypography.title2(this);
  
  /// Title 3: 20pt, SF Pro Display Semibold
  TextStyle get title3 => GlobalRemitTypography.title3(this);
  
  /// Headline: 17pt, SF Pro Text Semibold
  TextStyle get headline => GlobalRemitTypography.headline(this);
  
  /// Body: 17pt, SF Pro Text Regular
  TextStyle get body => GlobalRemitTypography.body(this);
  
  /// Callout: 16pt, SF Pro Text Regular
  TextStyle get callout => GlobalRemitTypography.callout(this);
  
  /// Subhead: 15pt, SF Pro Text Regular
  TextStyle get subhead => GlobalRemitTypography.subhead(this);
  
  /// Footnote: 13pt, SF Pro Text Regular
  TextStyle get footnote => GlobalRemitTypography.footnote(this);
  
  /// Caption 1: 12pt, SF Pro Text Regular
  TextStyle get caption1 => GlobalRemitTypography.caption1(this);
  
  /// Caption 2: 11pt, SF Pro Text Regular
  TextStyle get caption2 => GlobalRemitTypography.caption2(this);
}