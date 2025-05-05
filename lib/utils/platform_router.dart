import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';
import '../platforms/web/screens/navigation_wrapper.dart' as web;
import '../platforms/ios/screens/navigation_wrapper.dart' as ios;
import '../platforms/android/screens/navigation_wrapper.dart' as android;
import '../platforms/tablet/screens/navigation_wrapper.dart' as tablet;

/// A utility class that handles platform-specific routing
class PlatformRouter {
  /// Returns the appropriate navigation wrapper for the current platform
  static Widget getNavigationWrapper() {
    BuildContext? context;
    
    // Check if platform is tablet first (this check needs context)
    if (context != null && PlatformUtils.isTablet(context)) {
      return const tablet.TabletNavigationWrapper();
    }
    
    // Then check other platforms
    if (PlatformUtils.isWeb) {
      return const web.WebNavigationWrapper();
    } else if (PlatformUtils.isIOS) {
      return const ios.IOSNavigationWrapper();
    } else if (PlatformUtils.isAndroid) {
      return const android.AndroidNavigationWrapper();
    }
    
    // Default to iOS as fallback
    return const ios.IOSNavigationWrapper();
  }
  
  /// Returns the appropriate navigation wrapper with context awareness
  static Widget getNavigationWrapperWithContext(BuildContext context) {
    if (PlatformUtils.isTablet(context)) {
      return const tablet.TabletNavigationWrapper();
    } else if (PlatformUtils.isWeb) {
      return const web.WebNavigationWrapper();
    } else if (PlatformUtils.isIOS) {
      return const ios.IOSNavigationWrapper();
    } else if (PlatformUtils.isAndroid) {
      return const android.AndroidNavigationWrapper();
    }
    
    // Default to iOS
    return const ios.IOSNavigationWrapper();
  }
  
  /// Platform-aware page route
  static PageRoute getPageRoute({
    required Widget page,
    required RouteSettings settings,
  }) {
    if (PlatformUtils.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => page,
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
      );
    }
  }
}