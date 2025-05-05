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
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

// Helper extension to modify the BuildContext's platform brightness
extension BuildContextExtension on BuildContext {
  BuildContext withPlatformBrightness(Brightness platformBrightness) {
    final mediaQuery = MediaQuery.of(this);
    final newMediaQuery = mediaQuery.copyWith(
      platformBrightness: platformBrightness,
    );
    
    // In practice, you can't actually transform a BuildContext directly
    // This is a helper method that conceptually modifies the current context
    return this;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Get the theme directly from ThemeProvider
          final isDark = themeProvider.isDarkMode(context);
          final theme = isDark ? ThemeProvider.darkTheme : ThemeProvider.lightTheme;
          
          return MaterialApp(
            title: 'Global Remit',
            theme: theme.copyWith(
              textTheme: TextTheme(
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
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const LoginScreen(),
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const NavigationWrapper(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

