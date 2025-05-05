import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/navigation_wrapper.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/platform_utils.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Global Remit',
            theme: PlatformUtils.getPlatformTheme(context),
            darkTheme: PlatformUtils.getPlatformTheme(context),
                bodySmall: GlobalRemitTypography.subhead(context),
                labelLarge: GlobalRemitTypography.footnote(context),
                labelMedium: GlobalRemitTypography.caption1(context),
                labelSmall: GlobalRemitTypography.caption2(context),
              ),
              useMaterial3: true,
              cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(),
            ),
            themeMode: themeProvider.themeMode,
            home: const LoginScreen(),
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
}

