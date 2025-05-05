import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

enum CardVariant {
  elevated,
  filled,
  outlined,
}

class PlatformCard extends StatelessWidget {
  final Widget child;
  final CardVariant variant;
  final double? elevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;

  const PlatformCard({
    Key? key,
    required this.child,
    this.variant = CardVariant.elevated,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Determine card properties based on platform and variant
    late final double cardElevation;
    late final Color cardBackgroundColor;
    late final Color? cardBorderColor;
    
    switch (variant) {
      case CardVariant.elevated:
        cardElevation = elevation ?? (PlatformUtils.isIOS ? 0 : 1);
        cardBackgroundColor = backgroundColor ?? 
          (isDark ? const Color(0xFF1C1C1E) : Colors.white);
        cardBorderColor = borderColor ?? 
          (PlatformUtils.isIOS 
            ? (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1))
            : null);
        break;
      case CardVariant.filled:
        cardElevation = elevation ?? 0;
        cardBackgroundColor = backgroundColor ?? 
          (isDark 
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.surfaceVariant);
        cardBorderColor = borderColor;
        break;
      case CardVariant.outlined:
        cardElevation = elevation ?? 0;
        cardBackgroundColor = backgroundColor ?? 
          (isDark ? const Color(0xFF1C1C1E) : Colors.white);
        cardBorderColor = borderColor ?? 
          (isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1));
        break;
    }
    
    // Cupertino style card
    if (PlatformUtils.isIOS) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            border: cardBorderColor != null 
                ? Border.all(
                    color: cardBorderColor,
                    width: borderWidth,
                  )
                : null,
            boxShadow: cardElevation > 0 
                ? [
                    BoxShadow(
                      color: (shadowColor ?? Colors.black).withOpacity(0.1),
                      blurRadius: cardElevation * 4,
                      offset: Offset(0, cardElevation),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      );
    }
    
    // Material style card
    return Card(
      elevation: cardElevation,
      color: cardBackgroundColor,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        side: cardBorderColor != null 
            ? BorderSide(
                color: cardBorderColor,
                width: borderWidth,
              )
            : BorderSide.none,
      ),
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}