import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../screens/navigation_content_wrapper.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class IOSNavigationWrapper extends StatefulWidget {
  const IOSNavigationWrapper({super.key});

  @override
  State<IOSNavigationWrapper> createState() => _IOSNavigationWrapperState();
}

class _IOSNavigationWrapperState extends State<IOSNavigationWrapper> {
  int _selectedIndex = 0;
  final List<String> _pageTitles = ['Home', 'Transfers', 'Activity', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Resolve colors based on brightness
    final primaryBackgroundColor = isDark 
        ? GlobalRemitColors.primaryBackgroundDark 
        : GlobalRemitColors.primaryBackgroundLight;
        
    final primaryBlueColor = isDark
        ? GlobalRemitColors.primaryBlueDark
        : GlobalRemitColors.primaryBlueLight;
        
    final gray2Color = isDark
        ? GlobalRemitColors.gray2Dark
        : GlobalRemitColors.gray2Light;

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: primaryBackgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_right_arrow_left),
            activeIcon: Icon(CupertinoIcons.arrow_right_arrow_left),
            label: 'Transfers',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            activeIcon: Icon(CupertinoIcons.chart_bar_alt_fill),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        activeColor: primaryBlueColor,
        inactiveColor: gray2Color,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => NavigationContentWrapper(
            title: _pageTitles[index],
            selectedIndex: index,
            appBarLeading: Image.asset(
              Theme.of(context).brightness == Brightness.dark 
                ? 'assets/images/logo-light.svg.png' 
                : 'assets/images/logo-dark.svg.png',
              height: 24,
            ),
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
