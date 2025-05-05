import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/platform_utils.dart';
import '../platforms/web/screens/navigation_wrapper.dart';
import '../platforms/ios/screens/navigation_wrapper.dart';
import '../platforms/android/screens/navigation_wrapper.dart';
import '../platforms/tablet/screens/navigation_wrapper.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    // Use the correct platform-specific navigation wrapper
    if (PlatformUtils.isIOS) {
      return const IOSNavigationWrapper();
    } else if (PlatformUtils.isWeb) {
      return const WebNavigationWrapper();
    } else if (PlatformUtils.isTablet(context)) {
      return const TabletNavigationWrapper();
    } else {
      // Default to Android
      return const AndroidNavigationWrapper();
    }
  }
}
