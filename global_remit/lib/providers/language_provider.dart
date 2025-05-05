import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageProvider extends ChangeNotifier {
  // Default language
  Language _currentLanguage = Language.english;
  
  // Available languages in the app
  final List<Language> _availableLanguages = [
    Language.english,
    Language.spanish,
    Language.french,
    Language.arabic,
    Language.chinese,
    Language.german,
    Language.hindi,
  ];
  
  // Getter for current language
  Language get currentLanguage => _currentLanguage;
  
  // Getter for available languages
  List<Language> get availableLanguages => _availableLanguages;
  
  // Set language by code
  void setLanguage(String languageCode) {
    final language = _availableLanguages.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => Language.english,
    );
    
    _setLanguage(language);
  }
  
  // Set language by Language object
  void _setLanguage(Language language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      // In a real app, this would also update the app's locale
      // and save the preference to persistent storage
      notifyListeners();
    }
  }
  
  // Check if the app is using RTL language
  bool get isRtl => _currentLanguage.isRtl;
  
  // Get current locale
  Locale get locale => _currentLanguage.locale;
}