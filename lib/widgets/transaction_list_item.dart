import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/date_formatter.dart';
import 'status_badge.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final bool showDate;
  final VoidCallback? onTap;

  const TransactionListItem({
    Key? key,
    required this.transaction,
    this.showDate = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit || 
                    transaction.type == TransactionType.refund;
                    
    final amountColor = isCredit ? Colors.green : Colors.red;
    final amountPrefix = isCredit ? '+' : '-';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Transaction icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(transaction.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTransactionIcon(transaction.type),
                color: _getIconBackgroundColor(transaction.type),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (showDate) ...[
                        Text(
                          DateFormatter.formatDate(transaction.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        transaction.recipientName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Amount and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                StatusBadge(status: transaction.status, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.credit:
        return Icons.arrow_downward;
      case TransactionType.debit:
        return Icons.arrow_upward;
      case TransactionType.payment:
        return Icons.shopping_cart;
      case TransactionType.refund:
        return Icons.replay;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  Color _getIconBackgroundColor(TransactionType type) {
    switch (type) {
      case TransactionType.credit:
        return Colors.green;
      case TransactionType.debit:
        return Colors.red;
      case TransactionType.payment:
        return Colors.blue;
      case TransactionType.refund:
        return Colors.amber;
      case TransactionType.transfer:
        return Colors.purple;
    }
  }
}