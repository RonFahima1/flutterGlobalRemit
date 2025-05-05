import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

enum ButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  destructive,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const PlatformButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getDeviceType(context);
    
    if (platform == DeviceType.mobile || platform == DeviceType.tablet) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildCupertinoButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine button color based on variant
    Color? buttonColor;
    Color textColor;
    
    switch (variant) {
      case ButtonVariant.primary:
        buttonColor = theme.colorScheme.primary;
        textColor = Colors.white;
        break;
      case ButtonVariant.secondary:
        buttonColor = isDark 
          ? const Color(0xFF2C2C2E) 
          : const Color(0xFFE5E5EA);
        textColor = isDark ? Colors.white : Colors.black;
        break;
      case ButtonVariant.outlined:
        buttonColor = Colors.transparent;
        textColor = theme.colorScheme.primary;
        break;
      case ButtonVariant.text:
        buttonColor = null;
        textColor = theme.colorScheme.primary;
        break;
      case ButtonVariant.destructive:
        buttonColor = CupertinoColors.systemRed;
        textColor = Colors.white;
        break;
    }
    
    // Determine padding based on size
    EdgeInsets buttonPadding;
    double fontSize;
    
    switch (size) {
      case ButtonSize.small:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        );
        fontSize = 14;
        break;
      case ButtonSize.medium:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        );
        fontSize = 16;
        break;
      case ButtonSize.large:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        fontSize = 18;
        break;
    }
    
    // Apply custom padding if provided
    buttonPadding = padding ?? buttonPadding;
    
    // Button content
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null && !isLoading) ...[
          Icon(leadingIcon, color: textColor, size: fontSize + 4),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          CupertinoActivityIndicator(color: textColor)
        else
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (trailingIcon != null && !isLoading) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, color: textColor, size: fontSize + 4),
        ],
      ],
    );
    
    // Apply border for outlined variant
    if (variant == ButtonVariant.outlined) {
      return Container(
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: CupertinoButton(
          padding: buttonPadding,
          color: buttonColor,
          disabledColor: CupertinoColors.systemGrey4,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        ),
      );
    }
    
    // For text variant
    if (variant == ButtonVariant.text) {
      return CupertinoButton(
        padding: buttonPadding,
        onPressed: isLoading ? null : onPressed,
        child: buttonContent,
      );
    }
    
    // Default button
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: CupertinoButton(
        padding: buttonPadding,
        color: buttonColor,
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        onPressed: isLoading ? null : onPressed,
        child: buttonContent,
      ),
    );
  }

  Widget _buildMaterialButton(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine button style based on variant
    ButtonStyle buttonStyle;
    
    switch (variant) {
      case ButtonVariant.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 1,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
        break;
      case ButtonVariant.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
        break;
      case ButtonVariant.outlined:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
        break;
      case ButtonVariant.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
        break;
      case ButtonVariant.destructive:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: Colors.white,
          elevation: 1,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        );
        break;
    }
    
    // Determine padding based on size
    EdgeInsets buttonPadding;
    double fontSize;
    
    switch (size) {
      case ButtonSize.small:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        );
        fontSize = 14;
        break;
      case ButtonSize.medium:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        );
        fontSize = 16;
        break;
      case ButtonSize.large:
        buttonPadding = const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        );
        fontSize = 18;
        break;
    }
    
    // Apply custom padding if provided
    buttonPadding = padding ?? buttonPadding;
    
    // Button content
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null && !isLoading)
          Icon(leadingIcon, size: fontSize + 4),
        if (leadingIcon != null && !isLoading)
          const SizedBox(width: 8),
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: variant == ButtonVariant.outlined || variant == ButtonVariant.text
                  ? theme.colorScheme.primary
                  : Colors.white,
              strokeWidth: 2,
            ),
          )
        else
          Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        if (trailingIcon != null && !isLoading)
          const SizedBox(width: 8),
        if (trailingIcon != null && !isLoading)
          Icon(trailingIcon, size: fontSize + 4),
      ],
    );
    
    // Apply width constraint
    buttonContent = Container(
      width: isFullWidth ? double.infinity : null,
      alignment: Alignment.center,
      child: buttonContent,
    );
    
    // Return the appropriate button type
    switch (variant) {
      case ButtonVariant.outlined:
        return OutlinedButton(
          style: buttonStyle.copyWith(
            padding: MaterialStateProperty.all(buttonPadding),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
      case ButtonVariant.text:
        return TextButton(
          style: buttonStyle.copyWith(
            padding: MaterialStateProperty.all(buttonPadding),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
      default:
        return ElevatedButton(
          style: buttonStyle.copyWith(
            padding: MaterialStateProperty.all(buttonPadding),
          ),
          onPressed: isLoading ? null : onPressed,
          child: buttonContent,
        );
    }
  }
}
