import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/account.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class BalanceCard extends StatefulWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onBalanceTap;
  
  const BalanceCard({
    Key? key,
    required this.account,
    this.onTap,
    this.onBalanceTap,
  }) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with SingleTickerProviderStateMixin {
  bool _hideBalance = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _hideBalance = !_hideBalance;
    });
  }

  String _formatBalance(double balance) {
    if (_hideBalance) {
      return '•••••';
    }
    
    return balance.toStringAsFixed(2);
  }
  
  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: GlobalRemitSpacing.insetM),
          decoration: BoxDecoration(
            color: widget.account.color,
            borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusL),
            boxShadow: [
              BoxShadow(
                color: widget.account.color.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GlobalRemitSpacing.insetL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusM),
                ),
                child: const Icon(
                  CupertinoIcons.creditcard,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              
              // Visibility toggle
              GestureDetector(
                onTap: () {
                  _toggleBalanceVisibility();
                  if (widget.onBalanceTap != null) {
                    widget.onBalanceTap!();
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusM),
                  ),
                  child: Icon(
                    _hideBalance 
                      ? CupertinoIcons.eye_slash_fill 
                      : CupertinoIcons.eye_fill,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: GlobalRemitSpacing.insetL),
          
          // Balance label
          Text(
            'Balance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontFamily: 'SF Pro Text',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.24,
            ),
          ),
          
          const SizedBox(height: GlobalRemitSpacing.insetXS),
          
          // Balance amount with currency
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.account.currency,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.38,
                ),
              ),
              const SizedBox(width: GlobalRemitSpacing.insetXS),
              Text(
                _formatBalance(widget.account.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF Pro Display',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.37,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: GlobalRemitSpacing.insetL),
          
          // Account details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Account name
              Text(
                widget.account.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF Pro Text',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.24,
                ),
              ),
              
              // Account number (last 4 digits)
              Text(
                '•••• ${widget.account.number.substring(widget.account.number.length - 4)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'SF Pro Text',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}