import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/typography.dart';
import 'screens/auth/login_screen.dart';
import 'screens/navigation_wrapper.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred device orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide AuthProvider for authentication state management
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Provide ThemeProvider for theme state management
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Define the base light theme
          final lightTheme = ThemeProvider.lightTheme.copyWith(
            textTheme: _buildTextTheme(ThemeProvider.lightTheme.textTheme, context),
            useMaterial3: true,
          );
          // Define the base dark theme
          final darkTheme = ThemeProvider.darkTheme.copyWith(
            textTheme: _buildTextTheme(ThemeProvider.darkTheme.textTheme, context),
            useMaterial3: true,
          );

          return MaterialApp(
            title: 'Global Remit',
            // Provide the light theme
            theme: lightTheme,
            // Provide the dark theme
            darkTheme: darkTheme,
            // Let ThemeProvider control the active theme mode (light/dark/system)
            themeMode: themeProvider.themeMode,
            // Start with the splash screen
            home: const SplashScreen(),
            // Define the application routes
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const NavigationWrapper(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  // Helper method to apply custom typography to a base TextTheme
  TextTheme _buildTextTheme(TextTheme base, BuildContext context) {
    return base.copyWith(
      displayLarge: GlobalRemitTypography.largeTitle(context),
      displayMedium: GlobalRemitTypography.title1(context),
      displaySmall: GlobalRemitTypography.title2(context),
      headlineMedium: GlobalRemitTypography.title3(context),
      headlineSmall: GlobalRemitTypography.headline(context),
      titleLarge: GlobalRemitTypography.headline(context),
      bodyLarge: GlobalRemitTypography.body(context),
      bodyMedium: GlobalRemitTypography.callout(context),
      bodySmall: GlobalRemitTypography.subhead(context),
      labelLarge: GlobalRemitTypography.footnote(context),
      labelMedium: GlobalRemitTypography.caption1(context),
      labelSmall: GlobalRemitTypography.caption2(context),
    );
  }
}

