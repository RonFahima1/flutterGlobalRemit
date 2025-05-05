import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// A tab bar item configuration
class IOSTabItem {
  /// The icon to display when tab is not selected
  final IconData icon;
  
  /// The icon to display when tab is selected (optional)
  final IconData? activeIcon;
  
  /// The label text for the tab
  final String label;
  
  /// Optional badge count (shows a red badge with count)
  final int? badgeCount;

  const IOSTabItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

/// A tab bar component that follows iOS design guidelines
class IOSTabBar extends StatefulWidget {
  /// The list of tab items to display
  final List<IOSTabItem> items;
  
  /// The currently selected index
  final int currentIndex;
  
  /// Callback when a tab is selected
  final ValueChanged<int> onTap;
  
  /// Background color for the tab bar
  final Color? backgroundColor;
  
  /// Selected item color
  final Color? activeColor;
  
  /// Unselected item color
  final Color? inactiveColor;
  
  /// Whether to show a top border
  final bool showTopBorder;
  
  /// Whether to add a safe area at the bottom
  final bool addBottomSafeArea;

  const IOSTabBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.showTopBorder = true,
    this.addBottomSafeArea = true,
  }) : super(key: key);

  @override
  State<IOSTabBar> createState() => _IOSTabBarState();
}

class _IOSTabBarState extends State<IOSTabBar> with SingleTickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void didUpdateWidget(IOSTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animationControllers[oldWidget.currentIndex].reverse();
      _animationControllers[widget.currentIndex].forward();
    }
    
    if (widget.items.length != oldWidget.items.length) {
      _disposeAnimations();
      _initAnimations();
    }
  }

  void _initAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        value: index == widget.currentIndex ? 1.0 : 0.0,
      ),
    );
    
    _animations = _animationControllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ))
        .toList();
  }

  void _disposeAnimations() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color backgroundColor = widget.backgroundColor ?? 
        (isDark ? Colors.black : Colors.white);
    final Color activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final Color inactiveColor = widget.inactiveColor ?? 
        (isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93));
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: widget.showTopBorder ? Border(
          top: BorderSide(
            color: isDark ? Colors.grey[900]! : Colors.grey[300]!,
            width: 0.5,
          ),
        ) : null,
      ),
      child: SafeArea(
        top: false,
        bottom: widget.addBottomSafeArea,
        child: SizedBox(
          height: 49, // iOS standard tab bar height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.items.length, (index) {
              final IOSTabItem item = widget.items[index];
              final bool isSelected = index == widget.currentIndex;
              
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onTap(index),
                  child: AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                isSelected && item.activeIcon != null 
                                    ? item.activeIcon 
                                    : item.icon,
                                color: Color.lerp(
                                  inactiveColor,
                                  activeColor,
                                  _animations[index].value,
                                ),
                                size: 24 + (_animations[index].value * 2),
                              ),
                              if (item.badgeCount != null && item.badgeCount! > 0)
                                Positioned(
                                  top: 0,
                                  right: -6,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      item.badgeCount! < 10 ? 4 : 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: item.badgeCount! < 10 
                                          ? BoxShape.circle 
                                          : BoxShape.rectangle,
                                      borderRadius: item.badgeCount! < 10 
                                          ? null 
                                          : BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.badgeCount! > 99 
                                            ? '99+' 
                                            : item.badgeCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: _animations[index].value > 0.5 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                              color: Color.lerp(
                                inactiveColor,
                                activeColor,
                                _animations[index].value,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}