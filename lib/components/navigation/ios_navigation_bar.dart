import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class IOSNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool largeTitleDisplayMode;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onLeadingPressed;

  const IOSNavigationBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.largeTitleDisplayMode = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onLeadingPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = backgroundColor ?? (isDark 
      ? GlobalRemitColors.primaryBackgroundDark 
      : GlobalRemitColors.primaryBackgroundLight);
    final Color fgColor = foregroundColor ?? (isDark 
      ? GlobalRemitColors.primaryBlueDark 
      : GlobalRemitColors.primaryBlueLight);

    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading && Navigator.of(context).canPop()) {
      leadingWidget = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
        child: Icon(
          CupertinoIcons.back,
          color: fgColor,
        ),
      );
    }

    return CupertinoNavigationBar(
      middle: largeTitleDisplayMode ? null : Text(
        title,
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
      largeTitle: largeTitleDisplayMode ? Text(
        title,
        style: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ) : null,
      leading: leadingWidget,
      trailing: actions != null 
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ) 
        : null,
      backgroundColor: bgColor,
      border: elevation == null || elevation! > 0 
        ? Border(
            bottom: BorderSide(
              color: isDark 
                ? GlobalRemitColors.gray5Dark.withOpacity(0.3) 
                : GlobalRemitColors.gray5Light,
              width: 0.5,
            ),
          ) 
        : null,
      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    largeTitleDisplayMode 
      ? GlobalRemitSpacing.navBarLargeHeight 
      : GlobalRemitSpacing.navBarHeight
  );
}