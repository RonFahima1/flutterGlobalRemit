import 'package:flutter/material.dart';
import '../utils/platform_utils.dart';

/// A widget that renders different UI components based on the platform.
/// 
/// This wrapper detects the current platform and screen size to render the
/// appropriate UI component for web, iOS, Android, or tablet layouts.
class PlatformUIWrapper extends StatelessWidget {
  final Widget webUI;
  final Widget iOSUI;
  final Widget androidUI;
  final Widget? tabletUI;

  const PlatformUIWrapper({
    Key? key,
    required this.webUI,
    required this.iOSUI,
    required this.androidUI,
    this.tabletUI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // First check if it's a tablet, regardless of OS
    if (PlatformUtils.isTablet(context) && tabletUI != null) {
      return tabletUI!;
    }

    // Then check for specific platforms
    if (PlatformUtils.isWeb) {
      return webUI;
    } else if (PlatformUtils.isIOS) {
      return iOSUI;
    } else if (PlatformUtils.isAndroid) {
      return androidUI;
    }

    // Fallback to iOS UI as the default
    return iOSUI;
  }
}