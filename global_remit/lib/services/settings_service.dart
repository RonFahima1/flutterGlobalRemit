import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class SettingsService {
  // In a real app, this would use shared preferences or an API for persistence
  AppSettings _appSettings = AppSettings(
    themeMode: ThemeMode.system,
    language: 'English',
    notificationsEnabled: true,
    soundsEnabled: true,
    hapticFeedbackEnabled: true,
    currency: 'USD',
    analyticsEnabled: true,
    locationEnabled: true,
  );
  
  Future<AppSettings> getAppSettings() async {
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would fetch settings from shared preferences or an API
    return _appSettings;
  }
  
  Future<void> saveAppSettings({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? soundsEnabled,
    bool? hapticFeedbackEnabled,
    String? currency,
    bool? analyticsEnabled,
    bool? locationEnabled,
  }) async {
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would save settings to shared preferences or an API
    _appSettings = _appSettings.copyWith(
      themeMode: themeMode,
      language: language,
      notificationsEnabled: notificationsEnabled,
      soundsEnabled: soundsEnabled,
      hapticFeedbackEnabled: hapticFeedbackEnabled,
      currency: currency,
      analyticsEnabled: analyticsEnabled,
      locationEnabled: locationEnabled,
    );
  }
  
  Future<void> resetSettings() async {
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Reset to default settings
    _appSettings = AppSettings(
      themeMode: ThemeMode.system,
      language: 'English',
      notificationsEnabled: true,
      soundsEnabled: true,
      hapticFeedbackEnabled: true,
      currency: 'USD',
      analyticsEnabled: true,
      locationEnabled: true,
    );
  }
}