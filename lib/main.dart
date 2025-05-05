import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/typography.dart';
import 'screens/auth/login_screen.dart';
import 'screens/navigation_wrapper.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transfer_money_screen.dart';
import 'screens/transfer_confirmation_screen.dart';
import 'screens/international_remittance_screen.dart';

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
          // Define the base light theme with Global Remit styling
          final lightTheme = ThemeData(
            primaryColor: const Color(0xFF0066CC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0066CC),
              primary: const Color(0xFF0066CC),
              secondary: const Color(0xFFFFB800),
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
                side: const BorderSide(color: Color(0xFF0066CC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0066CC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            dividerTheme: DividerTheme.of(context).copyWith(
              color: Colors.grey.shade200,
            ),
            textTheme: _buildTextTheme(ThemeProvider.lightTheme.textTheme, context),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          );
          
          // Define the base dark theme with Global Remit styling
          final darkTheme = ThemeData(
            primaryColor: const Color(0xFF0066CC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0066CC),
              primary: const Color(0xFF0066CC),
              secondary: const Color(0xFFFFB800),
              brightness: Brightness.dark,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
                side: const BorderSide(color: Color(0xFF0066CC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0066CC),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0066CC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade800),
              ),
            ),
            dividerTheme: DividerTheme.of(context).copyWith(
              color: Colors.grey.shade800,
            ),
            textTheme: _buildTextTheme(ThemeProvider.darkTheme.textTheme, context),
            scaffoldBackgroundColor: Colors.grey.shade900,
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
            debugShowCheckedModeBanner: false,
            // Define the application routes
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const NavigationWrapper(),
            },
            // Use onGenerateRoute for dynamic route handling
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/dashboard':
                  return MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  );
                case '/transfer-money':
                  return MaterialPageRoute(
                    builder: (_) => const TransferMoneyScreen(),
                  );
                case '/international-remittance':
                  return MaterialPageRoute(
                    builder: (_) => const InternationalRemittanceScreen(),
                  );
                case '/transfer-confirmation':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => TransferConfirmationScreen(
                      transferDetails: args,
                    ),
                  );
                case '/beneficiaries':
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      appBar: AppBar(title: Text('Beneficiaries')),
                      body: Center(child: Text('Beneficiaries Screen - Coming Soon')),
                    ),
                  );
                case '/transfer-history':
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      appBar: AppBar(title: Text('Transfer History')),
                      body: Center(child: Text('Transfer History Screen - Coming Soon')),
                    ),
                  );
                case '/cards':
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      appBar: AppBar(title: Text('Cards')),
                      body: Center(child: Text('Cards Screen - Coming Soon')),
                    ),
                  );
                case '/transfer-details':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Transfer Details')),
                      body: Center(
                        child: Text(
                          'Transfer Details Screen - Coming Soon\n' +
                          (args != null ? 'Transfer ID: ${args['transferId']}' : ''),
                        ),
                      ),
                    ),
                  );
                case '/add-beneficiary':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Add Beneficiary')),
                      body: Center(
                        child: Text(
                          'Add Beneficiary Screen - Coming Soon\n' +
                          (args != null && args.containsKey('countryCode') 
                            ? 'Country: ${args['countryCode']}' 
                            : ''),
                        ),
                      ),
                    ),
                  );
                default:
                  // If no match is found, check if it's one of our basic routes
                  if (settings.name == '/login' || settings.name == '/home') {
                    return null; // Let the routes table handle these
                  }
                  // Otherwise, show a 404 page
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Page not found')),
                    ),
                  );
              }
            },
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

