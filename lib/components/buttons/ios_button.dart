import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

enum IOSButtonType {
  primary,   // Filled blue pill button
  secondary, // Outlined pill button
  text,      // Text only button
  destructive // Red action button
}

enum IOSButtonSize {
  small,  // Smaller button (32pt)
  medium, // Standard iOS button (44pt)
  large   // Larger button (50pt)
}

class IOSButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IOSButtonType type;
  final IOSButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final EdgeInsets? padding;
  final double? minWidth;

  const IOSButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.type = IOSButtonType.primary,
    this.size = IOSButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.padding,
    this.minWidth,
  }) : super(key: key);

  @override
  State<IOSButton> createState() => _IOSButtonState();
}

class _IOSButtonState extends State<IOSButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _isPressed = true;
      });
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isDisabled = widget.onPressed == null;
    
    // Get button height based on size
    double height;
    double fontSize;
    double iconSize;
    
    switch (widget.size) {
      case IOSButtonSize.small:
        height = GlobalRemitSpacing.buttonHeightS;
        fontSize = 13.0;
        iconSize = 16.0;
        break;
      case IOSButtonSize.large:
        height = GlobalRemitSpacing.buttonHeightL;
        fontSize = 17.0;
        iconSize = 20.0;
        break;
      case IOSButtonSize.medium:
      default:
        height = GlobalRemitSpacing.buttonHeightM;
        fontSize = 15.0;
        iconSize = 18.0;
        break;
    }
    
    // Get colors based on button type and state
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    switch (widget.type) {
      case IOSButtonType.primary:
        backgroundColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray5Dark : GlobalRemitColors.gray5Light)
            : (_isPressed ? GlobalRemitColors.primaryBlue.withOpacity(0.8) : GlobalRemitColors.primaryBlue);
        textColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray2Dark : GlobalRemitColors.gray2Light)
            : Colors.white;
        borderColor = Colors.transparent;
        break;
      case IOSButtonType.secondary:
        backgroundColor = Colors.transparent;
        textColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray2Dark : GlobalRemitColors.gray2Light)
            : (_isPressed ? GlobalRemitColors.primaryBlue.withOpacity(0.8) : GlobalRemitColors.primaryBlue);
        borderColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray3Dark : GlobalRemitColors.gray3Light)
            : (_isPressed ? GlobalRemitColors.primaryBlue.withOpacity(0.8) : GlobalRemitColors.primaryBlue);
        break;
      case IOSButtonType.destructive:
        backgroundColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray5Dark : GlobalRemitColors.gray5Light)
            : (_isPressed ? GlobalRemitColors.errorRedDark.withOpacity(0.8) : GlobalRemitColors.errorRedDark);
        textColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray2Dark : GlobalRemitColors.gray2Light)
            : Colors.white;
        borderColor = Colors.transparent;
        break;
      case IOSButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = isDisabled
            ? (isDark ? GlobalRemitColors.gray2Dark : GlobalRemitColors.gray2Light)
            : (_isPressed ? GlobalRemitColors.primaryBlue.withOpacity(0.8) : GlobalRemitColors.primaryBlue);
        borderColor = Colors.transparent;
        break;
    }
    
    // Build the button content
    Widget buttonContent = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingIcon != null && !widget.isLoading) ...[
          Icon(widget.leadingIcon, color: textColor, size: iconSize),
          SizedBox(width: 8.0),
        ],
        
        if (widget.isLoading) ...[
          SizedBox(
            height: iconSize,
            width: iconSize,
            child: CupertinoActivityIndicator(color: textColor),
          ),
          SizedBox(width: 8.0),
        ],
        
        Text(
          widget.label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: textColor,
            letterSpacing: 0.1,
          ),
        ),
        
        if (widget.trailingIcon != null && !widget.isLoading) ...[
          SizedBox(width: 8.0),
          Icon(widget.trailingIcon, color: textColor, size: iconSize),
        ],
      ],
    );
    
    // Apply scale animation
    buttonContent = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: buttonContent,
    );
    
    // Determine padding
    final EdgeInsets effectivePadding = widget.padding ??
        EdgeInsets.symmetric(
          horizontal: widget.type == IOSButtonType.text
              ? GlobalRemitSpacing.insetS
              : GlobalRemitSpacing.insetL,
          vertical: 0,
        );
    
    // Build the final button
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Container(
        height: height,
        width: widget.isFullWidth ? double.infinity : null,
        constraints: BoxConstraints(
          minWidth: widget.minWidth ?? 0.0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(height / 2), // Pill shape
          border: widget.type == IOSButtonType.secondary
              ? Border.all(color: borderColor, width: 1.0)
              : null,
        ),
        padding: effectivePadding,
        child: Center(child: buttonContent),
      ),
    );
  }
}
