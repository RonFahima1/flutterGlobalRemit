import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// A card that displays transaction details with iOS-style design
class TransactionCard extends StatefulWidget {
  /// Name of the recipient
  final String recipientName;
  
  /// Transaction amount
  final double amount;
  
  /// Currency code (e.g., USD, EUR)
  final String currency;
  
  /// Transaction date
  final DateTime date;
  
  /// Transaction status (completed, processing, failed)
  final String status;
  
  /// URL for recipient's profile image
  final String? recipientImageUrl;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.recipientName,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
    this.recipientImageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  // Controller for swipe actions
  final DismissDirection _dismissDirection = DismissDirection.endToStart;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Format the date
    final String formattedDate = _formatTransactionDate(widget.date);
    
    // Determine status color
    Color statusColor;
    IconData statusIcon;
    
    switch (widget.status.toLowerCase()) {
      case 'completed':
        statusColor = const Color(0xFF34C759); // iOS green
        statusIcon = CupertinoIcons.checkmark_circle_fill;
        break;
      case 'processing':
        statusColor = const Color(0xFFFF9500); // iOS orange
        statusIcon = CupertinoIcons.clock_fill;
        break;
      case 'failed':
        statusColor = const Color(0xFFFF3B30); // iOS red
        statusIcon = CupertinoIcons.exclamationmark_circle_fill;
        break;
      default:
        statusColor = const Color(0xFF8E8E93); // iOS gray
        statusIcon = CupertinoIcons.circle_fill;
    }
    
    return Dismissible(
      key: Key('transaction-${widget.recipientName}-${widget.date.millisecondsSinceEpoch}'),
      direction: _dismissDirection,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: const Color(0xFFFF3B30), // iOS red
        child: const Icon(
          CupertinoIcons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text('Are you sure you want to delete this transaction from your history?'),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) {
        // Handle deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction with ${widget.recipientName} deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Handle undo
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Recipient image or placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                  image: widget.recipientImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.recipientImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.recipientImageUrl == null
                    ? Icon(
                        CupertinoIcons.person_fill,
                        color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipientName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          color: statusColor,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.status.substring(0, 1).toUpperCase() + widget.status.substring(1),
                          style: TextStyle(
                            fontSize: 13,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white.withOpacity(0.6) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);
    
    if (dateToCheck == today) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE, ').add_jm().format(date);
    } else {
      return DateFormat.yMMMd().add_jm().format(date);
    }
  }
}