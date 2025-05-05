import 'package:flutter/material.dart';

/// Color constants for the Global Remit iOS-style design system
class GlobalRemitColors {
  /// Private constructor to prevent instantiation
  GlobalRemitColors._();
  
  /// iOS System Colors - Light Mode
  static const Color primaryBlueLight = Color(0xFF007AFF);
  static const Color secondaryGreenLight = Color(0xFF34C759);
  static const Color warningOrangeLight = Color(0xFFFF9500);
  static const Color errorRedLight = Color(0xFFFF3B30);
  
  /// iOS System Colors - Dark Mode
  static const Color primaryBlueDark = Color(0xFF0A84FF);
  static const Color secondaryGreenDark = Color(0xFF30D158);
  static const Color warningOrangeDark = Color(0xFFFF9F0A);
  static const Color errorRedDark = Color(0xFFFF453A);
  
  /// Background Colors - Light Mode
  static const Color primaryBackgroundLight = Colors.white;
  static const Color secondaryBackgroundLight = Color(0xFFF2F2F7);
  static const Color tertiaryBackgroundLight = Color(0xFFE5E5EA);
  
  /// Background Colors - Dark Mode
  static const Color primaryBackgroundDark = Colors.black;
  static const Color secondaryBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiaryBackgroundDark = Color(0xFF2C2C2E);
  
  /// Gray Scale - Light Mode
  static const Color gray1Light = Color(0xFF8E8E93);
  static const Color gray2Light = Color(0xFFAEAEB2);
  static const Color gray3Light = Color(0xFFC7C7CC);
  static const Color gray4Light = Color(0xFFD1D1D6);
  static const Color gray5Light = Color(0xFFE5E5EA);
  static const Color gray6Light = Color(0xFFF2F2F7);
  
  /// Gray Scale - Dark Mode
  static const Color gray1Dark = Color(0xFF8E8E93);
  static const Color gray2Dark = Color(0xFF636366);
  static const Color gray3Dark = Color(0xFF48484A);
  static const Color gray4Dark = Color(0xFF3A3A3C);
  static const Color gray5Dark = Color(0xFF2C2C2E);
  static const Color gray6Dark = Color(0xFF1C1C1E);
  
  /// Text Colors - Light Mode
  static const Color primaryTextLight = Colors.black;
  static const Color secondaryTextLight = Color(0x99000000); // 60% opacity
  static const Color tertiaryTextLight = Color(0x4D000000); // 30% opacity
  
  /// Text Colors - Dark Mode
  static const Color primaryTextDark = Colors.white;
  static const Color secondaryTextDark = Color(0x99FFFFFF); // 60% opacity
  static const Color tertiaryTextDark = Color(0x4DFFFFFF); // 30% opacity
  
  /// Semantic Colors
  static const Color successLight = Color(0xFF34C759);
  static const Color successDark = Color(0xFF30D158);
  static const Color warningLight = Color(0xFFFF9500);
  static const Color warningDark = Color(0xFFFF9F0A);
  static const Color errorLight = Color(0xFFFF3B30);
  static const Color errorDark = Color(0xFFFF453A);
  
  /// Brand Gradient - Light Mode
  static const List<Color> brandGradientLight = [
    Color(0xFF007AFF),
    Color(0xFF5AC8FA),
  ];
  
  /// Brand Gradient - Dark Mode
  static const List<Color> brandGradientDark = [
    Color(0xFF0062CC),
    Color(0xFF0A84FF),
  ];
  
  /// Returns the appropriate color based on the brightness
  static Color resolveColor(BuildContext context, Color lightColor, Color darkColor) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightColor : darkColor;
  }
}

/// Extension to easily access theme colors from context
extension GlobalRemitColorsExtension on BuildContext {
  /// Primary blue color (iOS blue)
  Color get primaryBlue => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.primaryBlueLight, 
    GlobalRemitColors.primaryBlueDark
  );
  
  /// Secondary green color (iOS green)
  Color get secondaryGreen => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.secondaryGreenLight, 
    GlobalRemitColors.secondaryGreenDark
  );
  
  /// Warning orange color (iOS orange)
  Color get warningOrange => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.warningOrangeLight, 
    GlobalRemitColors.warningOrangeDark
  );
  
  /// Error red color (iOS red)
  Color get errorRed => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.errorRedLight, 
    GlobalRemitColors.errorRedDark
  );
  
  /// Primary background color
  Color get primaryBackground => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.primaryBackgroundLight, 
    GlobalRemitColors.primaryBackgroundDark
  );
  
  /// Secondary background color
  Color get secondaryBackground => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.secondaryBackgroundLight, 
    GlobalRemitColors.secondaryBackgroundDark
  );
  
  /// Tertiary background color
  Color get tertiaryBackground => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.tertiaryBackgroundLight, 
    GlobalRemitColors.tertiaryBackgroundDark
  );
  
  /// Gray 1 color
  Color get gray1 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray1Light, 
    GlobalRemitColors.gray1Dark
  );
  
  /// Gray 2 color
  Color get gray2 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray2Light, 
    GlobalRemitColors.gray2Dark
  );
  
  /// Gray 3 color
  Color get gray3 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray3Light, 
    GlobalRemitColors.gray3Dark
  );
  
  /// Gray 4 color
  Color get gray4 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray4Light, 
    GlobalRemitColors.gray4Dark
  );
  
  /// Gray 5 color
  Color get gray5 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray5Light, 
    GlobalRemitColors.gray5Dark
  );
  
  /// Gray 6 color
  Color get gray6 => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.gray6Light, 
    GlobalRemitColors.gray6Dark
  );
  
  /// Primary text color
  Color get primaryText => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.primaryTextLight, 
    GlobalRemitColors.primaryTextDark
  );
  
  /// Secondary text color
  Color get secondaryText => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.secondaryTextLight, 
    GlobalRemitColors.secondaryTextDark
  );
  
  /// Tertiary text color
  Color get tertiaryText => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.tertiaryTextLight, 
    GlobalRemitColors.tertiaryTextDark
  );
  
  /// Success color
  Color get success => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.successLight, 
    GlobalRemitColors.successDark
  );
  
  /// Warning color
  Color get warning => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.warningLight, 
    GlobalRemitColors.warningDark
  );
  
  /// Error color
  Color get error => GlobalRemitColors.resolveColor(
    this, 
    GlobalRemitColors.errorLight, 
    GlobalRemitColors.errorRedDark
  );
  
  /// Brand gradient colors
  List<Color> get brandGradient => Theme.of(this).brightness == Brightness.light
      ? GlobalRemitColors.brandGradientLight
      : GlobalRemitColors.brandGradientDark;
}
