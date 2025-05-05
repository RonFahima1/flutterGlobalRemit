import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Responsive layout builder for different screen sizes
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
           MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024 &&
           MediaQuery.of(context).size.width < 1200;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Return the appropriate layout based on screen size
    if (width >= 1200 && web != null) return web!;
    if (width >= 1024 && desktop != null) return desktop!;
    if (width >= 600 && tablet != null) return tablet!;
    return mobile;
  }
}

/// Responsive padding builder
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final EdgeInsets? web;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // Use the appropriate padding based on screen size
    final padding = width >= 1200 
        ? web ?? desktop ?? tablet ?? mobile ?? EdgeInsets.zero
        : width >= 1024 
        ? desktop ?? tablet ?? mobile ?? EdgeInsets.zero
        : width >= 600 
        ? tablet ?? mobile ?? EdgeInsets.zero
        : mobile ?? EdgeInsets.zero;

    return Padding(padding: padding, child: child);
  }
}

/// Responsive spacing constants
class ResponsiveSpacing {
  static const double mobileSpacing = 8.0;
  static const double tabletSpacing = 16.0;
  static const double desktopSpacing = 24.0;
  static const double webSpacing = 32.0;

  static double getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return webSpacing;
    if (width >= 1024) return desktopSpacing;
    if (width >= 600) return tabletSpacing;
    return mobileSpacing;
  }
}
