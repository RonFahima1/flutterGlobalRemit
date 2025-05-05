import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base_navigation_wrapper.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class IOSNavigationWrapper extends StatefulWidget {
  const IOSNavigationWrapper({super.key});

  @override
  State<IOSNavigationWrapper> createState() => _IOSNavigationWrapperState();
}

class _IOSNavigationWrapperState extends State<IOSNavigationWrapper> {
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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_up),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_down),
            label: 'Receive',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        activeColor: GlobalRemitColors.primaryBlue(context),
        inactiveColor: GlobalRemitColors.gray2(context),
        onTap: _onItemTapped,
        backgroundColor: GlobalRemitColors.primaryBackground(context),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _widgetOptions[index];
          },
        );
      },
    );
  }
}
