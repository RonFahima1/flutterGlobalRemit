import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../screens/base_navigation_wrapper.dart';
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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
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
        activeColor: GlobalRemitColors.primaryBlue(context),
        inactiveColor: GlobalRemitColors.gray2(context),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: GlobalRemitColors.primaryBackground(context),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(_pageTitles[index]),
                trailing: index == 3 
                  ? Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text('Log Out'),
                          onPressed: () {
                            authProvider.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        );
                      },
                    )
                  : null,
                backgroundColor: GlobalRemitColors.primaryBackground(context),
              ),
              child: SafeArea(
                child: BaseNavigationWrapper(pageTitle: _pageTitles[index]),
              ),
            );
          },
        );
      },
    );
  }
}
