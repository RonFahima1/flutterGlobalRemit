import 'package:flutter/material.dart';
import '../../base/theme/base_theme.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

/// Web-specific theme implementation
class WebTheme extends BaseTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: getColorScheme(context),
      textTheme: getTextTheme(context),
      appBarTheme: getAppBarTheme(context),
      cardTheme: getCardTheme(context),
      buttonTheme: getButtonTheme(context),
      scaffoldBackgroundColor: GlobalRemitColors.primaryBackground(context),
    );
  }

  static ColorScheme getColorScheme(BuildContext context, {bool isDark = false}) {
    return ColorScheme.fromSeed(
      seedColor: GlobalRemitColors.primaryBlue(context),
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: GlobalRemitColors.primaryBlue(context),
      secondary: GlobalRemitColors.secondaryGreen(context),
      background: GlobalRemitColors.primaryBackground(context),
      surface: GlobalRemitColors.secondaryBackground(context),
      onPrimary: Colors.white,
      onSecondary: GlobalRemitColors.gray1(context),
      onBackground: GlobalRemitColors.gray1(context),
      onSurface: GlobalRemitColors.gray1(context),
      error: GlobalRemitColors.errorRed(context),
      onError: Colors.white,
    );
  }

  static TextTheme getTextTheme(BuildContext context) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  static AppBarTheme getAppBarTheme(BuildContext context) {
    return AppBarTheme(
      backgroundColor: GlobalRemitColors.primaryBackground(context),
      foregroundColor: GlobalRemitColors.gray1(context),
      elevation: 1,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  static CardTheme getCardTheme(BuildContext context) {
    return CardTheme(
      color: GlobalRemitColors.secondaryBackground(context),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static ButtonThemeData getButtonTheme(BuildContext context) {
    return ButtonThemeData(
      buttonColor: GlobalRemitColors.primaryBlue(context),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
}
