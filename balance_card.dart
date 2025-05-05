import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/spacing.dart';
import '../cards/ios_card.dart';

/// A premium iOS-style card that displays the user's balance
class BalanceCard extends StatefulWidget {
  /// The current balance amount
  final double balance;
  
  /// The currency code (e.g., USD, EUR)
  final String currencyCode;
  
  /// Whether to show the full balance or hide it with asterisks
  final bool showBalance;
  
  /// Callback when the visibility toggle is pressed
  final VoidCallback? onToggleVisibility;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Whether to show a gradient background
  final bool useGradient;
  
  /// Optional subtitle text
  final String? subtitle;

  const BalanceCard({
    Key? key,
    required this.balance,
    required this.currencyCode,
    this.showBalance = true,
    this.onToggleVisibility,
    this.onTap,
    this.useGradient = true,
    this.subtitle,
  }) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  String _formatBalance(double balance) {
    return balance.toStringAsFixed(2);
  }
  
  String _formatCurrency(String currencyCode) {
    return currencyCode.toUpperCase();
  }
  
  String _hideBalance(double balance) {
    return '••••••';
  }
  
  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.mediumImpact();
      widget.onTap!();
    }
  }
  
  void _handleToggleVisibility() {
    if (widget.onToggleVisibility != null) {
      HapticFeedback.selectionClick();
      widget.onToggleVisibility!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Card background
    Widget backgroundContent;
    if (widget.useGradient) {
      backgroundContent = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [const Color(0xFF0062CC), const Color(0xFF0A84FF)]
                : [const Color(0xFF007AFF), const Color(0xFF5AC8FA)],
          ),
          borderRadius: BorderRadius.circular(GlobalRemitSpacing.cardBorderRadius),
        ),
      );
    } else {
      backgroundContent = Container(
        decoration: BoxDecoration(
          color: isDark ? GlobalRemitColors.secondaryBackgroundDark : GlobalRemitColors.primaryBlueLight,
          borderRadius: BorderRadius.circular(GlobalRemitSpacing.cardBorderRadius),
        ),
      );
    }
    
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 180,
          margin: const EdgeInsets.symmetric(
            horizontal: GlobalRemitSpacing.insetM,
            vertical: GlobalRemitSpacing.insetS,
          ),
          child: Stack(
            children: [
              // Background
              Positioned.fill(child: backgroundContent),
              
              // Frosted glass effect for iOS feel
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(GlobalRemitSpacing.cardBorderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(GlobalRemitSpacing.insetL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Available Balance',
                      style: GlobalRemitTypography.subhead(
                        context, 
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: GlobalRemitSpacing.insetM),
                    
                    // Balance Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Currency symbol
                        Container(
                          padding: const EdgeInsets.all(GlobalRemitSpacing.insetXS),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(GlobalRemitSpacing.insetXS),
                          ),
                          child: Text(
                            _formatCurrency(widget.currencyCode),
                            style: GlobalRemitTypography.footnote(
                              context,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: GlobalRemitSpacing.insetS),
                        
                        // Balance amount
                        Expanded(
                          child: Text(
                            widget.showBalance 
                                ? _formatBalance(widget.balance)
                                : _hideBalance(widget.balance),
                            style: GlobalRemitTypography.title1(
                              context,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        // Visibility toggle
                        if (widget.onToggleVisibility != null)
                          IconButton(
                            icon: Icon(
                              widget.showBalance 
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _handleToggleVisibility,
                          ),
                      ],
                    ),
                    
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: GlobalRemitSpacing.insetS),
                      Text(
                        widget.subtitle!,
                        style: GlobalRemitTypography.footnote(
                          context,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Bottom row with last updated info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Updated just now',
                          style: GlobalRemitTypography.caption2(
                            context,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}