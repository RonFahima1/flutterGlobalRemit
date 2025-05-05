import 'package:flutter/material.dart';

/// Base navigation wrapper that can be extended by platform-specific implementations.
/// This is an abstract class that defines the interface for platform-specific navigation wrappers.
abstract class BaseNavigationWrapper {
  final String title;
  final int selectedIndex;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final ValueChanged<int>? onTabSelected;
  final Widget? child;

  const BaseNavigationWrapper({
    required this.title,
    required this.selectedIndex,
    this.appBarLeading,
    this.appBarActions,
    this.onTabSelected,
    this.child,
  });
  
  /// Returns the appropriate content based on the selected index
  Widget getContentForIndex(BuildContext context) {
    // Render different content based on the selected index
    switch (selectedIndex) {
      case 0:
        return buildHomeScreen(context);
      case 1:
        return buildTransfersScreen(context);
      case 2:
        return buildActivityScreen(context);
      case 3:
        return buildProfileScreen(context);
      default:
        return buildHomeScreen(context);
    }
  }
  
  /// Build the home/dashboard screen
  Widget buildHomeScreen(BuildContext context);
  
  /// Build the transfers screen
  Widget buildTransfersScreen(BuildContext context);
  
  /// Build the activity screen
  Widget buildActivityScreen(BuildContext context);
  
  /// Build the profile screen
  Widget buildProfileScreen(BuildContext context);
}
