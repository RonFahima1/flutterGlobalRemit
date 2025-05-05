import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/platform_utils.dart';
import '../../theme/theme_constants.dart';
import '../../theme/colors.dart';
import '../base_navigation_wrapper.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getDeviceType(context);

    switch (platform) {
      case DeviceType.mobile:
        return const BaseNavigationWrapper();
      case DeviceType.tablet:
        return const BaseNavigationWrapper();
      case DeviceType.desktop:
        return const BaseNavigationWrapper();
      default:
        return const BaseNavigationWrapper();
    }
                  label: 'Profile',
                  icon: CupertinoIcons.person,
                  activeIcon: CupertinoIcons.person_fill,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
