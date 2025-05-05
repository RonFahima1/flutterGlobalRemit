import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/animations.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class IOSTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool hasError;

  const IOSTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.icon = Icons.text_fields,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = hasError
        ? GlobalRemitColors.errorRed(context)
        : GlobalRemitColors.gray2(context);

    return AppAnimations.iosSpringAnimation(
      visible: true,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        placeholderStyle: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray2(context)),
        prefix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        suffix: obscureText
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.visibility_off,
                  color: color,
                ),
              )
            : null,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: BoxDecoration(
          color: GlobalRemitColors.secondaryBackground(context),
          borderRadius: BorderRadius.circular(13),
        ),
        enabled: enabled,
        style: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray1(context)),
        validator: validator,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
