import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'transfer_money_screen.dart';
import 'international_remittance_screen.dart';
import 'transfers/transfers_screen.dart';
import 'activity/activity_screen.dart';
import 'profile_screen.dart';
import 'base_navigation_wrapper.dart';

/// A concrete implementation of BaseNavigationWrapper that can be instantiated.
/// This class provides the actual implementation for platform-specific navigation wrappers.
class NavigationContentWrapper extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final ValueChanged<int>? onTabSelected;
  final Widget? child;

  const NavigationContentWrapper({
    Key? key, 
    this.title = 'Dashboard',
    this.selectedIndex = 0,
    this.appBarLeading,
    this.appBarActions,
    this.onTabSelected,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the appropriate content based on the selected index
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading,
        title: Text(title),
        actions: appBarActions,
        elevation: 0,
      ),
      body: child ?? _getContentForIndex(selectedIndex),
    );
  }

  /// Returns the appropriate content based on the selected index
  Widget _getContentForIndex(int index) {
    // Render different content based on the selectedIndex
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TransferMoneyScreen();
      case 2:
        return const InternationalRemittanceScreen();
      case 3:
        return const TransfersScreen();
      case 4:
        return const ProfileScreen();
      default:
        return Center(
          child: Text('Page not found for index: $index'),
        );
    }
  }
}
