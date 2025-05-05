import 'package:flutter/material.dart';
import '../../../utils/animations.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class WebButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final bool isDestructive;

  const WebButton({
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

    return AppAnimations.webHoverAnimation(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          backgroundColor: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
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
