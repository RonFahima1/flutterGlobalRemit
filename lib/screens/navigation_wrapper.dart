import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';
import '../widgets/platform_ui_wrapper.dart';
import '../platforms/web/screens/navigation_wrapper.dart' as web;
import '../platforms/ios/screens/navigation_wrapper.dart' as ios;
import '../platforms/android/screens/navigation_wrapper.dart' as android;
import '../platforms/tablet/screens/navigation_wrapper.dart' as tablet;

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformUIWrapper(
      webUI: const web.WebNavigationWrapper(),
      iOSUI: const ios.IOSNavigationWrapper(),
      androidUI: const android.AndroidNavigationWrapper(),
      tabletUI: const tablet.TabletNavigationWrapper(),
    );
  }
}
