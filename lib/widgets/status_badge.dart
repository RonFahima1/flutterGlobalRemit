import 'package:flutter/material.dart';
import '../models/transaction.dart';

class StatusBadge extends StatelessWidget {
  final TransactionStatus status;
  final bool compact;

  const StatusBadge({
    Key? key,
    required this.status,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 12,
        vertical: compact ? 2 : 6,
      ),
      decoration: BoxDecoration(
        color: statusConfig['color']!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(compact ? 4 : 8),
        border: Border.all(
          color: statusConfig['color']!.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(
              statusConfig['icon'] as IconData,
              size: 14,
              color: statusConfig['color'],
            ),
            const SizedBox(width: 4),
          ],
          Text(
            compact ? statusConfig['shortLabel'] as String : statusConfig['label'] as String,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w500,
              color: statusConfig['color'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return {
          'color': Colors.green,
          'icon': Icons.check_circle,
          'label': 'Completed',
          'shortLabel': 'Done',
        };
      case TransactionStatus.pending:
        return {
          'color': Colors.orange,
          'icon': Icons.pending,
          'label': 'Pending',
          'shortLabel': 'Pending',
        };
      case TransactionStatus.failed:
        return {
          'color': Colors.red,
          'icon': Icons.error,
          'label': 'Failed',
          'shortLabel': 'Failed',
        };
      case TransactionStatus.cancelled:
        return {
          'color': Colors.grey,
          'icon': Icons.cancel,
          'label': 'Cancelled',
          'shortLabel': 'Cancelled',
        };
    }
  }
}