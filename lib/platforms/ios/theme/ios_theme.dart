import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../base/theme/base_theme.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

/// iOS-specific theme implementation
class IOSTheme extends BaseTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: getColorScheme(context),
      textTheme: getTextTheme(context),
      appBarTheme: getAppBarTheme(context),
      cardTheme: getCardTheme(context),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: GlobalRemitTypography.title3(context)
            .copyWith(color: GlobalRemitColors.gray1(context)),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }
}
