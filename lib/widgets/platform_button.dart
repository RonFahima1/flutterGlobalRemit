import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/platform_utils.dart';
import '../../../platforms/ios/widgets/ios_button.dart';
import '../../../platforms/web/widgets/web_button.dart';

class PlatformButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final bool isDestructive;

  const PlatformButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_ios,
    this.isLoading = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getDeviceType(context);

    switch (platform) {
      case DeviceType.mobile:
      case DeviceType.tablet:
        return IOSButton(
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          isDestructive: isDestructive,
        );
      case DeviceType.desktop:
        return WebButton(
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          isDestructive: isDestructive,
        );
      default:
        return WebButton(
          label: label,
          onPressed: onPressed,
          icon: icon,
          isLoading: isLoading,
          isDestructive: isDestructive,
        );
    }
  }
}
