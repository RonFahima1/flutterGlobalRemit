import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A card component that follows iOS design guidelines
class IOSCard extends StatefulWidget {
  /// The content of the card
  final Widget child;
  
  /// Whether the card is interactive (responds to taps)
  final bool interactive;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;
  
  /// Background color of the card
  final Color? backgroundColor;
  
  /// Border radius of the card
  final BorderRadius? borderRadius;
  
  /// Elevation (shadow) of the card
  final double elevation;
  
  /// Padding inside the card
  final EdgeInsetsGeometry contentPadding;
  
  /// Margin around the card
  final EdgeInsetsGeometry margin;
  
  /// Border of the card
  final Border? border;

  const IOSCard({
    Key? key,
    required this.child,
    this.interactive = false,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 1,
    this.contentPadding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.border,
  }) : super(key: key);

  @override
  State<IOSCard> createState() => _IOSCardState();
}

class _IOSCardState extends State<IOSCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.interactive || widget.onTap == null) return;
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.interactive || widget.onTap == null) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.interactive || widget.onTap == null) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (!widget.interactive || widget.onTap == null) return;
    HapticFeedback.selectionClick();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Default card background color based on theme
    final Color cardColor = widget.backgroundColor ?? 
        (isDark ? const Color(0xFF1C1C1E) : Colors.white);
    
    // Default border radius
    final BorderRadius borderRadius = widget.borderRadius ?? 
        BorderRadius.circular(13);
    
    // Shadow color based on theme
    final Color shadowColor = isDark 
        ? Colors.black.withOpacity(0.5) 
        : Colors.black.withOpacity(0.1);
    
    // Build the card with conditional animation
    Widget cardWidget = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: borderRadius,
        border: widget.border,
        boxShadow: widget.elevation > 0 
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: widget.elevation * 4,
                  spreadRadius: widget.elevation * 0.2,
                  offset: Offset(0, widget.elevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: widget.contentPadding,
          child: widget.child,
        ),
      ),
    );
    
    // If card is not interactive, return it directly
    if (!widget.interactive) {
      return cardWidget;
    }
    
    // Otherwise, wrap it with gesture detector and animation
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: cardWidget,
      ),
    );
  }
}