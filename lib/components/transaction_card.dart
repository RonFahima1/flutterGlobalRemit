import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/transaction.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final Function(Transaction)? onDelete;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isIncoming = widget.transaction.type == TransactionType.RECEIVE;
    
    return Dismissible(
      key: Key(widget.transaction.id),
      direction: widget.onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: _buildDismissBackground(),
      confirmDismiss: (_) async {
        if (widget.onDelete != null) {
          widget.onDelete!(widget.transaction);
          return true;
        }
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: Colors.transparent,
          highlightColor: isDark
              ? GlobalRemitColors.gray6Dark.withOpacity(0.1)
              : GlobalRemitColors.gray6Light.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: GlobalRemitSpacing.insetM,
              horizontal: GlobalRemitSpacing.insetM,
            ),
            child: Row(
              children: [
                // Transaction category icon
                _buildCategoryIcon(),
                const SizedBox(width: GlobalRemitSpacing.insetM),
                
                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction.description,
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(widget.transaction.date),
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 13,
                          letterSpacing: -0.08,
                          color: isDark
                              ? GlobalRemitColors.gray2Dark
                              : GlobalRemitColors.gray1Light,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Transaction amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (isIncoming)
                          const Icon(
                            CupertinoIcons.arrow_down_left,
                            size: 12,
                            color: GlobalRemitColors.secondaryGreen,
                          )
                        else
                          const Icon(
                            CupertinoIcons.arrow_up_right,
                            size: 12,
                            color: Color(0xFFFF3B30), // iOS red
                          ),
                        const SizedBox(width: 4),
                        Text(
                          '${isIncoming ? '+' : '-'} ${widget.transaction.currency} ${widget.transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.41,
                            color: isIncoming
                                ? GlobalRemitColors.secondaryGreen
                                : isDark
                                    ? GlobalRemitColors.errorRedDark
                                    : GlobalRemitColors.errorRedLight,
                          ),
                        ),
                      ],
                    ),
                    if (widget.transaction.fee != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Fee: ${widget.transaction.currency} ${widget.transaction.fee!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 13,
                          letterSpacing: -0.08,
                          color: isDark
                              ? GlobalRemitColors.gray2Dark
                              : GlobalRemitColors.gray1Light,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    IconData iconData;
    Color iconColor;
    Color backgroundColor;
    
    // Determine icon and colors based on transaction type
    switch (widget.transaction.type) {
      case TransactionType.SEND:
        iconData = CupertinoIcons.arrow_up;
        iconColor = isDark
            ? GlobalRemitColors.errorRedDark
            : GlobalRemitColors.errorRedLight;
        backgroundColor = isDark
            ? GlobalRemitColors.gray5Dark
            : GlobalRemitColors.gray5Light;
        break;
      case TransactionType.RECEIVE:
        iconData = CupertinoIcons.arrow_down;
        iconColor = GlobalRemitColors.secondaryGreen;
        backgroundColor = isDark
            ? GlobalRemitColors.gray5Dark
            : GlobalRemitColors.gray5Light;
        break;
      case TransactionType.EXCHANGE:
        iconData = CupertinoIcons.arrow_right_arrow_left;
        iconColor = isDark
            ? Colors.white
            : Colors.black;
        backgroundColor = isDark
            ? GlobalRemitColors.gray5Dark
            : GlobalRemitColors.gray5Light;
        break;
      case TransactionType.TRANSFER:
        iconData = CupertinoIcons.arrow_right;
        iconColor = GlobalRemitColors.primaryBlue;
        backgroundColor = isDark
            ? GlobalRemitColors.gray5Dark
            : GlobalRemitColors.gray5Light;
        break;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusM),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: GlobalRemitColors.errorRedLight,
      padding: const EdgeInsets.symmetric(horizontal: GlobalRemitSpacing.insetL),
      alignment: Alignment.centerRight,
      child: const Icon(
        CupertinoIcons.delete,
        color: Colors.white,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);
    
    if (transactionDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (transactionDate == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}