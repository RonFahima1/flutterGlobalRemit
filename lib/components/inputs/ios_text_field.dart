import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class IOSTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;

  const IOSTextField({
    Key? key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark 
      ? GlobalRemitColors.gray1Dark 
      : GlobalRemitColors.gray1Light;
    final Color backgroundColor = isDark 
      ? GlobalRemitColors.tertiaryBackgroundDark 
      : GlobalRemitColors.tertiaryBackgroundLight;
    final Color textColor = isDark 
      ? Colors.white 
      : Colors.black;
    final Color placeholderColor = isDark 
      ? GlobalRemitColors.gray2Dark 
      : GlobalRemitColors.gray2Light;
    final Color errorColor = isDark 
      ? GlobalRemitColors.errorRedDark 
      : GlobalRemitColors.errorRedLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: labelColor,
              fontFamily: 'SF Pro Text',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: GlobalRemitSpacing.insetXS),
        ],
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusS),
            border: Border.all(
              color: errorText != null 
                ? errorColor 
                : backgroundColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (prefix != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: GlobalRemitSpacing.insetS),
                  child: prefix,
                ),
              ],
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  autofocus: autofocus,
                  enabled: enabled,
                  maxLines: maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlobalRemitSpacing.insetM,
                    vertical: GlobalRemitSpacing.insetS,
                  ),
                  placeholder: placeholder,
                  placeholderStyle: TextStyle(
                    color: placeholderColor,
                    fontFamily: 'SF Pro Text',
                    fontSize: 17,
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'SF Pro Text',
                    fontSize: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusS),
                  ),
                ),
              ),
              if (suffix != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: GlobalRemitSpacing.insetS),
                  child: suffix,
                ),
              ],
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: GlobalRemitSpacing.insetXS),
          Text(
            errorText!,
            style: TextStyle(
              color: errorColor,
              fontFamily: 'SF Pro Text',
              fontSize: 13,
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: GlobalRemitSpacing.insetXS),
          Text(
            helperText!,
            style: TextStyle(
              color: labelColor,
              fontFamily: 'SF Pro Text',
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}