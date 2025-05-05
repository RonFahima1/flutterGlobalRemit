import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// GlobalRemit Colors - Following iOS Design Guidelines
class GlobalRemitColors {
  // Primary Colors
  static const Color primaryBlueLight = Color(0xFF007AFF); // iOS Blue
  static const Color primaryBlueDark = Color(0xFF0A84FF);
  static const Color secondaryGreenLight = Color(0xFF34C759); // iOS Green
  static const Color secondaryGreenDark = Color(0xFF30D158);
  static const Color warningOrangeLight = Color(0xFFFF9500); // iOS Orange
  static const Color warningOrangeDark = Color(0xFFFF9F0A);
  static const Color errorRedLight = Color(0xFFFF3B30); // iOS Red
  static const Color errorRedDark = Color(0xFFFF453A);

  // Gray Scale - Light Mode (iOS Standard Grays)
  static const Color gray1Light = Color(0xFF8E8E93); // System Gray
  static const Color gray2Light = Color(0xFFAEAEB2); // System Gray 2
  static const Color gray3Light = Color(0xFFC7C7CC); // System Gray 3
  static const Color gray4Light = Color(0xFFD1D1D6); // System Gray 4
  static const Color gray5Light = Color(0xFFE5E5EA); // System Gray 5
  static const Color gray6Light = Color(0xFFF2F2F7); // System Gray 6

  // Gray Scale - Dark Mode (iOS Standard Grays)
  static const Color gray1Dark = Color(0xFF8E8E93); // System Gray
  static const Color gray2Dark = Color(0xFF636366); // System Gray 2
  static const Color gray3Dark = Color(0xFF48484A); // System Gray 3
  static const Color gray4Dark = Color(0xFF3A3A3C); // System Gray 4
  static const Color gray5Dark = Color(0xFF2C2C2E); // System Gray 5
  static const Color gray6Dark = Color(0xFF1C1C1E); // System Gray 6

  // Background Colors
  static const Color primaryBackgroundLight = Colors.white; // System Background
  static const Color primaryBackgroundDark = Colors.black; // System Background
  static const Color secondaryBackgroundLight = Color(0xFFF2F2F7); // System Grouped Background
  static const Color secondaryBackgroundDark = Color(0xFF1C1C1E); // System Grouped Background
  static const Color tertiaryBackgroundLight = Color(0xFFE5E5EA); // System Secondary Grouped Background
  static const Color tertiaryBackgroundDark = Color(0xFF2C2C2E); // System Secondary Grouped Background

  // Separator Colors
  static const Color separatorLight = Color(0x33000000); // 20% black
  static const Color separatorDark = Color(0x33FFFFFF); // 20% white

  // Dynamic color getters
  static Color primaryBlue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryBlueDark
        : primaryBlueLight;
  }

  static Color secondaryGreen(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryGreenDark
        : secondaryGreenLight;
  }

  static Color warningOrange(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? warningOrangeDark
        : warningOrangeLight;
  }

  static Color errorRed(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? errorRedDark
        : errorRedLight;
  }

  static Color gray1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray1Dark
        : gray1Light;
  }

  static Color gray2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray2Dark
        : gray2Light;
  }

  static Color gray3(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray3Dark
        : gray3Light;
  }

  static Color gray4(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray4Dark
        : gray4Light;
  }

  static Color gray5(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray5Dark
        : gray5Light;
  }

  static Color gray6(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray6Dark
        : gray6Light;
  }

  static Color primaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryBackgroundDark
        : primaryBackgroundLight;
  }

  static Color secondaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryBackgroundDark
        : secondaryBackgroundLight;
  }

  static Color tertiaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? tertiaryBackgroundDark
        : tertiaryBackgroundLight;
  }

  static Color separator(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? GlobalRemitColors.separatorDark
        : GlobalRemitColors.separatorLight;
  }

  Color getColor(BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.dark ? darkColor : lightColor;
  }
}
