import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class IOSTabBarItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool showBadge;
  final int? badgeCount;

  const IOSTabBarItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.showBadge = false,
    this.badgeCount,
  });
}

class IOSTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<IOSTabBarItem> items;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const IOSTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = backgroundColor ?? (isDark 
      ? GlobalRemitColors.tertiaryBackgroundDark 
      : GlobalRemitColors.tertiaryBackgroundLight);
    final Color activeFgColor = activeColor ?? (isDark 
      ? GlobalRemitColors.primaryBlueDark 
      : GlobalRemitColors.primaryBlueLight);
    final Color inactiveFgColor = inactiveColor ?? (isDark 
      ? GlobalRemitColors.gray2Dark 
      : GlobalRemitColors.gray2Light);

    return Container(
      height: GlobalRemitSpacing.tabBarHeight,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark 
              ? GlobalRemitColors.gray5Dark.withOpacity(0.3) 
              : GlobalRemitColors.gray5Light,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _buildTabItem(
            context,
            items[index],
            index == currentIndex,
            () => onTap(index),
            activeFgColor,
            inactiveFgColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    IOSTabBarItem item,
    bool isActive,
    VoidCallback onTap,
    Color activeColor,
    Color inactiveColor,
  ) {
    final Color color = isActive ? activeColor : inactiveColor;
    final IconData effectiveIcon = isActive && item.activeIcon != null 
        ? item.activeIcon! 
        : item.icon;
    
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  effectiveIcon,
                  color: color,
                  size: 24,
                ),
                
                // Badge
                if (item.showBadge)
                  Positioned(
                    top: 0,
                    right: -4,
                    child: _buildBadge(context, item.badgeCount),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                color: color,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, int? count) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Badge background color is always red regardless of theme
    final badgeColor = isDark 
        ? Colors.red 
        : Colors.red;
    
    final double size = count != null ? 16.0 : 8.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: count != null ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: count != null ? BorderRadius.circular(8.0) : null,
      ),
      child: count != null
          ? Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}

