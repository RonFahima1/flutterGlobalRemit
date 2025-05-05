import 'package:flutter/material.dart';

class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flagAsset;
  final Locale locale;
  final bool isRtl;
  
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagAsset,
    required this.locale,
    this.isRtl = false,
  });
  
  // Predefined languages
  static const Language english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flagAsset: 'assets/flags/us.png',
    locale: Locale('en', 'US'),
  );
  
  static const Language spanish = Language(
    code: 'es',
    name: 'Spanish',
    nativeName: 'Español',
    flagAsset: 'assets/flags/es.png',
    locale: Locale('es', 'ES'),
  );
  
  static const Language french = Language(
    code: 'fr',
    name: 'French',
    nativeName: 'Français',
    flagAsset: 'assets/flags/fr.png',
    locale: Locale('fr', 'FR'),
  );
  
  static const Language arabic = Language(
    code: 'ar',
    name: 'Arabic',
    nativeName: 'العربية',
    flagAsset: 'assets/flags/sa.png',
    locale: Locale('ar', 'SA'),
    isRtl: true,
  );
  
  static const Language chinese = Language(
    code: 'zh',
    name: 'Chinese',
    nativeName: '中文',
    flagAsset: 'assets/flags/cn.png',
    locale: Locale('zh', 'CN'),
  );
  
  static const Language german = Language(
    code: 'de',
    name: 'German',
    nativeName: 'Deutsch',
    flagAsset: 'assets/flags/de.png',
    locale: Locale('de', 'DE'),
  );
  
  static const Language hindi = Language(
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिन्दी',
    flagAsset: 'assets/flags/in.png',
    locale: Locale('hi', 'IN'),
  );
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.code == code;
  }
  
  @override
  int get hashCode => code.hashCode;
}