import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/animations.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class IOSButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final bool isDestructive;

  const IOSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_ios,
    this.isLoading = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? GlobalRemitColors.errorRed(context)
        : GlobalRemitColors.primaryBlue(context);

    return AppAnimations.iosSpringAnimation(
      visible: true,
      child: CupertinoButton.filled(
        onPressed: isLoading ? null : onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        borderRadius: BorderRadius.circular(13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CupertinoActivityIndicator(
                radius: 12,
              )
            else
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GlobalRemitTypography.body(context)
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
