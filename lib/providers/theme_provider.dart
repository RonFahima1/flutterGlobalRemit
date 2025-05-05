import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
  
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  
  // Convenience method to directly set light mode
  void setLightMode() {
    setThemeMode(ThemeMode.light);
  }
  
  // Convenience method to directly set dark mode
  void setDarkMode() {
    setThemeMode(ThemeMode.dark);
  }
  
  // Convenience method to use system settings
  void useSystemTheme() {
    setThemeMode(ThemeMode.system);
  }
  
  // Get the appropriate theme based on platform
  ThemeData getPlatformTheme(BuildContext context) {
    final isDark = isDarkMode(context);
    
    // Return appropriate theme based on platform
    if (PlatformUtils.isIOS) {
      return getIOSTheme(isDark: isDark);
    } else if (PlatformUtils.isAndroid) {
      return getAndroidTheme(isDark: isDark);
    } else if (PlatformUtils.isWeb) {
      return getWebTheme(isDark: isDark);
    } else {
      // Default theme
      return isDark ? darkTheme : lightTheme;
    }
  }

  // Web-specific theme
  static ThemeData getWebTheme({required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: isDark ? const Color(0xFF242424) : Colors.white,
      ),
      dividerColor: isDark ? Colors.white24 : Colors.black12,
    );
  }

  // iOS-specific theme
  static ThemeData getIOSTheme({required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark 
          ? CupertinoColors.darkBackgroundGray 
          : CupertinoColors.systemBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark 
            ? CupertinoColors.darkBackgroundGray 
            : CupertinoColors.systemBackground,
        foregroundColor: isDark ? CupertinoColors.white : CupertinoColors.black,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDark 
            ? const Color(0xFF1C1C1E) 
            : CupertinoColors.systemBackground,
      ),
      dividerColor: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey4,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: const Color(0xFF0A84FF),
        scaffoldBackgroundColor: isDark 
            ? CupertinoColors.darkBackgroundGray 
            : CupertinoColors.systemBackground,
      ),
    );
  }

  // Android-specific theme
  static ThemeData getAndroidTheme({required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      cardTheme: CardTheme(
        elevation: isDark ? 1 : 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? const Color(0xFF4285F4) : const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    );
  }

  // Tablet-specific theme
  static ThemeData getTabletTheme({required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDark ? const Color(0xFF242424) : Colors.white,
      ),
      dividerColor: isDark ? Colors.white24 : Colors.black12,
    );
  }
}
