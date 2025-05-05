import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/platform_utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final String _prefKey = 'theme_mode';

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  
  // Get if dark mode is active without requiring a BuildContext
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Get from system
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  // For backward compatibility
  bool isDarkModeFromContext(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveThemePrefs();
    }
  }
  
  // Load saved theme preferences
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_prefKey);
      if (savedTheme != null) {
        if (savedTheme == 'light') {
          _themeMode = ThemeMode.light;
        } else if (savedTheme == 'dark') {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.system;
        }
        notifyListeners();
      }
    } catch (e) {
      // If there's an error, use system default
      _themeMode = ThemeMode.system;
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_themeMode == ThemeMode.light) {
        await prefs.setString(_prefKey, 'light');
      } else if (_themeMode == ThemeMode.dark) {
        await prefs.setString(_prefKey, 'dark');
      } else {
        await prefs.setString(_prefKey, 'system');
      }
    } catch (e) {
      // Ignore save errors - will just fall back to default next time
    }
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

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
  
  // Convenience method to directly set light mode
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }
  
  // Convenience method to directly set dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }
  
  // Convenience method to use system settings
  Future<void> useSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
  
  // Get the appropriate theme based on platform
  ThemeData getPlatformTheme(BuildContext context) {
    final isDark = isDarkModeFromContext(context);
    
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
