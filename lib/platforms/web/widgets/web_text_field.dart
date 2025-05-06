import 'package:flutter/material.dart';
import '../../../utils/animations.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class WebTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool hasError;

  const WebTextField({
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

    return AppAnimations.webHoverAnimation(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GlobalRemitTypography.body(context).copyWith(
            color: GlobalRemitColors.gray2(context),
            fontWeight: FontWeight.w500,
          ),
          hintText: placeholder,
          hintStyle: GlobalRemitTypography.body(context).copyWith(
            color: GlobalRemitColors.gray2(context).withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: GlobalRemitColors.gray3(context),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: GlobalRemitColors.gray3(context),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: GlobalRemitColors.primaryBlue(context),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: GlobalRemitColors.errorRed(context),
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: GlobalRemitColors.errorRed(context),
              width: 1.5,
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: color,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: obscureText
              ? Icon(
                  Icons.visibility_off,
                  color: color,
                )
              : null,
          enabled: enabled,
          filled: true,
          fillColor: GlobalRemitColors.secondaryBackground(context),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray1(context)),
      ),
    );
  }
}
