import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

class PlatformTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;

  const PlatformTextField({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.border,
    this.borderRadius,
    this.contentPadding,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformUtils.isIOS
        ? _buildCupertinoTextField(context)
        : _buildMaterialTextField(context);
  }

  Widget _buildCupertinoTextField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine border color
    Color borderColor = errorText != null
        ? CupertinoColors.systemRed
        : isDark
            ? CupertinoColors.systemGrey
            : CupertinoColors.systemGrey4;
    
    // Create prefix widget if needed
    Widget? prefixWidget;
    if (prefix != null) {
      prefixWidget = prefix;
    } else if (prefixIcon != null) {
      prefixWidget = Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Icon(
          prefixIcon,
          color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
          size: 20,
        ),
      );
    }
    
    // Create suffix widget if needed
    Widget? suffixWidget;
    if (suffix != null) {
      suffixWidget = suffix;
    } else if (suffixIcon != null) {
      suffixWidget = Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(
          suffixIcon,
          color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
          size: 20,
        ),
      );
    }
    
    // Build the text field
    Widget textField = CupertinoTextField(
      controller: controller,
      placeholder: placeholder ?? label,
      prefix: prefixWidget,
      suffix: suffixWidget,
      padding: contentPadding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      obscureText: obscureText,
      autofocus: autofocus,
      enabled: enabled,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      decoration: BoxDecoration(
        border: border ?? Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
      ),
      style: TextStyle(
        color: isDark ? CupertinoColors.white : CupertinoColors.black,
        fontSize: 16,
      ),
      placeholderStyle: TextStyle(
        color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
        fontSize: 16,
      ),
    );
    
    // Add label if provided
    if (label != null) {
      textField = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              label!,
              style: TextStyle(
                color: isDark ? CupertinoColors.white : CupertinoColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          textField,
        ],
      );
    }
    
    // Add error text if provided
    if (errorText != null) {
      textField = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textField,
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    } 
    // Add helper text if provided
    else if (helperText != null) {
      textField = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textField,
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              helperText!,
              style: TextStyle(
                color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }
    
    return textField;
  }

  Widget _buildMaterialTextField(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        prefix: prefix,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        suffix: suffix,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1,
          ),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      obscureText: obscureText,
      autofocus: autofocus,
      enabled: enabled,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
    );
  }
}
