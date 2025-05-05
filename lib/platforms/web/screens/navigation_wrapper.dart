import 'package:flutter/material.dart';
import '../../base_navigation_wrapper.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class WebNavigationWrapper extends StatefulWidget {
  const WebNavigationWrapper({super.key});

  @override
  State<WebNavigationWrapper> createState() => _WebNavigationWrapperState();
}

class _WebNavigationWrapperState extends State<WebNavigationWrapper> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    Text('Home'),
    Text('Send'),
    Text('Receive'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            backgroundColor: GlobalRemitColors.primaryBackground(context),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.send),
                selectedIcon: Icon(Icons.send),
                label: Text('Send'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Receive'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          // Main content area
          Expanded(
            child: Container(
              color: GlobalRemitColors.secondaryBackground(context),
              child: Center(
                child: _widgetOptions[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
