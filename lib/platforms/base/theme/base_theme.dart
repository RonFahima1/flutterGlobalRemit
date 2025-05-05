import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/theme_constants.dart';

class BaseTheme {
  static ThemeData getTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: GlobalRemitColors.primaryBlue(context),
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: GlobalRemitTypography.largeTitle(context),
        displayMedium: GlobalRemitTypography.title1(context),
        displaySmall: GlobalRemitTypography.title2(context),
        headlineMedium: GlobalRemitTypography.title3(context),
        headlineSmall: GlobalRemitTypography.title4(context),
        bodyLarge: GlobalRemitTypography.body(context),
        bodyMedium: GlobalRemitTypography.caption1(context),
        bodySmall: GlobalRemitTypography.caption2(context),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: GlobalRemitColors.primaryBackground(context),
        foregroundColor: GlobalRemitColors.gray1(context),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GlobalRemitColors.secondaryBackground(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: GlobalRemitColors.gray2(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: GlobalRemitColors.primaryBlue(context),
          ),
        ),
      ),
    );
  }
}
