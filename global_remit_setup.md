# Global Remit Project Setup

Follow these steps to create a new Flutter project with the Global Remit iOS-style design system.

## 1. Create a new Flutter project

```bash
flutter create global_remit
cd global_remit
```

## 2. Update dependencies in pubspec.yaml

Replace the contents of your `pubspec.yaml` file with:

```yaml
name: global_remit
description: A premium iOS-style remittance application.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=2.19.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.5
  flutter_svg: ^2.0.5
  intl: ^0.18.0
  provider: ^6.0.5
  shared_preferences: ^2.1.1
  flutter_secure_storage: ^8.0.0
  local_auth: ^2.1.6
  animations: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: SF Pro Display
      fonts:
        - asset: assets/fonts/SF-Pro-Display-Regular.otf
        - asset: assets/fonts/SF-Pro-Display-Medium.otf
          weight: 500
        - asset: assets/fonts/SF-Pro-Display-Semibold.otf
          weight: 600
        - asset: assets/fonts/SF-Pro-Display-Bold.otf
          weight: 700
    - family: SF Pro Text
      fonts:
        - asset: assets/fonts/SF-Pro-Text-Regular.otf
        - asset: assets/fonts/SF-Pro-Text-Medium.otf
          weight: 500
        - asset: assets/fonts/SF-Pro-Text-Semibold.otf
          weight: 600
        - asset: assets/fonts/SF-Pro-Text-Bold.otf
          weight: 700
```

## 3. Create the project directory structure

Create the following directory structure:

```
lib/
├── components/
│   ├── buttons/
│   ├── cards/
│   ├── dashboard/
│   ├── inputs/
│   └── transactions/
├── models/
├── screens/
│   ├── auth/
│   ├── dashboard/
│   ├── profile/
│   └── transactions/
├── services/
├── theme/
└── utils/
```

Run these commands to create the directory structure:

```bash
mkdir -p lib/components/buttons
mkdir -p lib/components/cards
mkdir -p lib/components/dashboard
mkdir -p lib/components/inputs
mkdir -p lib/components/transactions
mkdir -p lib/models
mkdir -p lib/screens/auth
mkdir -p lib/screens/dashboard
mkdir -p lib/screens/profile
mkdir -p lib/screens/transactions
mkdir -p lib/services
mkdir -p lib/theme
mkdir -p lib/utils
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
```

## 4. Download SF Pro fonts

For the authentic iOS look, you'll need the SF Pro fonts. Since these are Apple's proprietary fonts, you should download them from Apple's developer website:

1. Visit [https://developer.apple.com/fonts/](https://developer.apple.com/fonts/)
2. Download the SF Pro fonts
3. Extract the downloaded file
4. Copy the following files to your `assets/fonts/` directory:
   - SF-Pro-Display-Regular.otf
   - SF-Pro-Display-Medium.otf
   - SF-Pro-Display-Semibold.otf
   - SF-Pro-Display-Bold.otf
   - SF-Pro-Text-Regular.otf
   - SF-Pro-Text-Medium.otf
   - SF-Pro-Text-Semibold.otf
   - SF-Pro-Text-Bold.otf

## 5. Create a colors.dart file

Create a file at `lib/theme/colors.dart` with the following content:

```dart
import 'package:flutter/material.dart';

class GlobalRemitColors {
  // iOS System Colors
  static const Color primaryBlueLight = Color(0xFF007AFF);
  static const Color primaryBlueDark = Color(0xFF0A84FF);
  
  static const Color secondaryGreenLight = Color(0xFF34C759);
  static const Color secondaryGreenDark = Color(0xFF30D158);
  
  static const Color warningOrangeLight = Color(0xFFFF9500);
  static const Color warningOrangeDark = Color(0xFFFF9F0A);
  
  static const Color errorRedLight = Color(0xFFFF3B30);
  static const Color errorRedDark = Color(0xFFFF453A);
  
  // Gray Scale
  static const Color gray1Light = Color(0xFF8E8E93);
  static const Color gray1Dark = Color(0xFF8E8E93);
  
  static const Color gray2Light = Color(0xFFAEAEB2);
  static const Color gray2Dark = Color(0xFFAEAEB2);
  
  static const Color gray3Light = Color(0xFFC7C7CC);
  static const Color gray3Dark = Color(0xFFC7C7CC);
  
  static const Color gray4Light = Color(0xFFD1D1D6);
  static const Color gray4Dark = Color(0xFFD1D1D6);
  
  static const Color gray5Light = Color(0xFFE5E5EA);
  static const Color gray5Dark = Color(0xFFE5E5EA);
  
  static const Color gray6Light = Color(0xFFF2F2F7);
  static const Color gray6Dark = Color(0xFFF2F2F7);
  
  // Background Colors
  static const Color primaryBackgroundLight = Colors.white;
  static const Color primaryBackgroundDark = Colors.black;
  
  static const Color secondaryBackgroundLight = Color(0xFFF2F2F7);
  static const Color secondaryBackgroundDark = Color(0xFF1C1C1E);
  
  static const Color tertiaryBackgroundLight = Color(0xFFE5E5EA);
  static const Color tertiaryBackgroundDark = Color(0xFF2C2C2E);
  
  // Get color based on brightness
  static Color getColor(BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.light
        ? lightColor
        : darkColor;
  }
}
```

## 6. Create a typography.dart file

Create a file at `lib/theme/typography.dart` with the following content:

```dart
import 'package:flutter/material.dart';

class GlobalRemitTypography {
  // Large Title: 34pt, SF Pro Display Bold
  static TextStyle largeTitle(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
      color: color,
    );
  }
  
  // Title 1: 28pt, SF Pro Display Bold
  static TextStyle title1(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
      color: color,
    );
  }
  
  // Title 2: 22pt, SF Pro Display Bold
  static TextStyle title2(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      color: color,
    );
  }
  
  // Title 3: 20pt, SF Pro Display Semibold
  static TextStyle title3(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
      color: color,
    );
  }
  
  // Headline: 17pt, SF Pro Text Semibold
  static TextStyle headline(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: color,
    );
  }
  
  // Body: 17pt, SF Pro Text Regular
  static TextStyle body(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: color,
    );
  }
  
  // Callout: 16pt, SF Pro Text Regular
  static TextStyle callout(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: color,
    );
  }
  
  // Subhead: 15pt, SF Pro Text Regular
  static TextStyle subhead(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: color,
    );
  }
  
  // Footnote: 13pt, SF Pro Text Regular
  static TextStyle footnote(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      color: color,
    );
  }
  
  // Caption 1: 12pt, SF Pro Text Regular
  static TextStyle caption1(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      color: color,
    );
  }
  
  // Caption 2: 11pt, SF Pro Text Regular
  static TextStyle caption2(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      color: color,
    );
  }
}
```

## 7. Create a basic card component

Create a file at `lib/components/cards/ios_card.dart` with the following content:

```dart
import 'package:flutter/material.dart';
import '../../theme/spacing.dart';

class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final double? borderRadius;
  final VoidCallback? onTap;
  
  const IOSCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.all(GlobalRemitSpacing.insetM),
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: BorderRadius.circular(borderRadius ?? GlobalRemitSpacing.cardBorderRadius),
          boxShadow: [
            if (elevation != null && elevation! > 0)
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
                blurRadius: elevation! * 4,
                offset: Offset(0, elevation! * 0.5),
              ),
          ],
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(GlobalRemitSpacing.insetM),
          child: child,
        ),
      ),
    );
  }
}
```

## 8. Update the main.dart file

Replace the contents of `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GlobalRemitApp());
}

class GlobalRemitApp extends StatelessWidget {
  const GlobalRemitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Remit',
      theme: GlobalRemitTheme.getLightTheme(),
      darkTheme: GlobalRemitTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Remit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Global Remit',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Your premium iOS-style remittance app',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 9. Run the project

Now you can run your project:

```bash
flutter pub get
flutter run
```

This will start your app with the basic iOS-style theme applied. You can now continue adding the components we've created to build out the full application.