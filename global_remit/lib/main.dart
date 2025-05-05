import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';
import 'routes.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        // Add other providers as needed
      ],
      child: const GlobalRemitApp(),
    ),
  );
}

class GlobalRemitApp extends StatelessWidget {
  const GlobalRemitApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to language changes to update the app locale
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return MaterialApp(
      title: 'Global Remit',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // This could be a user preference
      locale: languageProvider.locale, // Set the app locale based on selected language
      supportedLocales: languageProvider.availableLanguages.map((l) => l.locale).toList(),
      // In a real app, you would also add localization delegates here
      // to load translations based on the selected locale
      routes: AppRoutes.routes,
      home: const SplashScreen(),
      builder: (context, child) {
        // Add the floating language button to all screens
        // This wraps every screen with our language button
        return Directionality(
          // Handle RTL languages
          textDirection: languageProvider.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Stack(
            children: [
              child!,
              // You can position this where needed or make it conditionally visible
              Positioned(
                right: 16,
                bottom: 80, // Position above the main FAB if there is one
                child: _buildFloatingLanguageButton(context),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFloatingLanguageButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'languageButton',
      mini: true,
      elevation: 4,
      onPressed: () {
        // Show language selector
        showDialog(
          context: context,
          builder: (context) => _buildLanguageDialog(context),
        );
      },
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.language,
        color: Colors.blue,
      ),
    );
  }
  
  Widget _buildLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.language, color: Colors.blue),
          SizedBox(width: 8),
          Text('Select Language'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: languageProvider.availableLanguages.length,
          itemBuilder: (context, index) {
            final language = languageProvider.availableLanguages[index];
            final isSelected = language == languageProvider.currentLanguage;
            
            return ListTile(
              leading: CircleAvatar(
                child: Text(language.code.toUpperCase()),
              ),
              title: Text(language.name),
              subtitle: Text(language.nativeName),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                languageProvider.setLanguage(language.code);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

// Home screen has been moved to its own file
