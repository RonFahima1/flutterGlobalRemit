import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Platform detection utilities
/// Detects the current platform and provides platform-specific utilities
class PlatformUtils {
  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// Check if running on desktop (macOS, Windows, Linux)
  static bool get isDesktop => !kIsWeb && (isMacOS || isWindows || isLinux);
  
  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => !kIsWeb && (isIOS || isAndroid);

  /// Get the current platform as a string
  static String getPlatform() {
    if (isWeb) return 'web';
    if (isIOS) return 'ios';
    if (isAndroid) return 'android';
    if (isMacOS) return 'macos';
    if (isWindows) return 'windows';
    if (isLinux) return 'linux';
    return 'unknown';
  }

  /// Check if the device is a tablet
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return width > 600 || height > 600;
  }

  /// Check if the device is a desktop/laptop
  static bool isDesktopSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return width > 1200;
  }

  /// Get the device type
  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    
    if (width > 1200) {
      return DeviceType.desktop;
    } else if (width > 600) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  /// Get the current platform theme
  static ThemeData getPlatformTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isDark = themeProvider.isDarkMode(context);
    
    // Return appropriate theme based on platform
    if (isIOS) {
      return isDark ? ThemeProvider.darkTheme : ThemeProvider.lightTheme;
    } else if (isAndroid) {
      return isDark ? ThemeProvider.darkTheme : ThemeProvider.lightTheme;
    } else {
      return isDark ? ThemeProvider.darkTheme : ThemeProvider.lightTheme;
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
  bool get isWeb => PlatformUtils.isWeb;
  bool get isIOS => PlatformUtils.isIOS;
  bool get isAndroid => PlatformUtils.isAndroid;
  bool get isDesktop => PlatformUtils.isDesktop;
  bool get isMobile => PlatformUtils.isMobile;
  bool get isTablet => PlatformUtils.isTablet(this);
  bool get isDesktopSize => PlatformUtils.isDesktopSize(this);
  DeviceType get deviceType => PlatformUtils.getDeviceType(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
}
