import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform detection utilities
/// Detects the current platform and provides platform-specific utilities
class PlatformUtils {
  /// Check if running on web
  static bool isWeb() => kIsWeb;

  /// Check if running on iOS
  static bool isIOS() => Platform.isIOS;

  /// Check if running on Android
  static bool isAndroid() => Platform.isAndroid;

  /// Check if running on desktop (macOS, Windows, Linux)
  static bool isDesktop() => 
      Platform.isMacOS || 
      Platform.isWindows || 
      Platform.isLinux;

  /// Get the current platform as a string
  static String getPlatform() {
    if (isWeb()) return 'web';
    if (isIOS()) return 'ios';
    if (isAndroid()) return 'android';
    if (isDesktop()) return 'desktop';
    return 'unknown';
  }

  /// Check if the device is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }

  /// Check if the device is a desktop/laptop
  static bool isDesktopSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1024;
  }

  /// Get the device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (isWeb()) {
      if (width >= 1024) {
        return DeviceType.desktop;
      }
      return DeviceType.mobile;
    }

    if (isTablet(context)) {
      return DeviceType.tablet;
    }

    return DeviceType.mobile;
  }

  /// Get the current platform theme
  static ThemeData getPlatformTheme(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return BaseTheme.getTheme(context, isDark: isDark);
      case DeviceType.tablet:
        return BaseTheme.getTheme(context, isDark: isDark);
      case DeviceType.desktop:
        return BaseTheme.getTheme(context, isDark: isDark);
    }
  }
}

/// Device types for responsive design
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Platform-specific theme extensions
extension PlatformThemeExtensions on BuildContext {
  bool get isWeb => PlatformUtils.isWeb();
  bool get isIOS => PlatformUtils.isIOS();
  bool get isAndroid => PlatformUtils.isAndroid();
  bool get isDesktop => PlatformUtils.isDesktop();
  DeviceType get deviceType => PlatformUtils.getDeviceType(this);
}
