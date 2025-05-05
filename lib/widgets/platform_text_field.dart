import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/platform_utils.dart';
import '../../../platforms/ios/widgets/ios_text_field.dart';
import '../../../platforms/web/widgets/web_text_field.dart';

class PlatformTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool hasError;

  const PlatformTextField({
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
    final platform = PlatformUtils.getDeviceType(context);

    switch (platform) {
      case DeviceType.mobile:
      case DeviceType.tablet:
        return IOSTextField(
          label: label,
          placeholder: placeholder,
          icon: icon,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          enabled: enabled,
          hasError: hasError,
        );
      case DeviceType.desktop:
        return WebTextField(
          label: label,
          placeholder: placeholder,
          icon: icon,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          enabled: enabled,
          hasError: hasError,
        );
      default:
        return WebTextField(
          label: label,
          placeholder: placeholder,
          icon: icon,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          enabled: enabled,
          hasError: hasError,
        );
    }
  }
}
