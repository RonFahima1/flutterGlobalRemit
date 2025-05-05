import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/transaction.dart';
import '../../theme/colors.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/status_badge.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  Widget _buildStatusBar(BuildContext context) {
    final statusConfig = _getStatusConfig(transaction.status);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      color: statusConfig['color'],
      child: Column(
        children: [
          Icon(
            statusConfig['icon'] as IconData,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            statusConfig['title'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            statusConfig['message'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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
          'title': 'Completed',
          'message': 'Transaction has been successfully processed',
        };
      case TransactionStatus.pending:
        return {
          'color': Colors.orange,
          'icon': Icons.pending,
          'title': 'Pending',
          'message': 'Transaction is being processed',
        };
      case TransactionStatus.failed:
        return {
          'color': Colors.red,
          'icon': Icons.error,
          'title': 'Failed',
          'message': 'Transaction could not be processed',
        };
      case TransactionStatus.cancelled:
        return {
          'color': Colors.grey,
          'icon': Icons.cancel,
          'title': 'Cancelled',
          'message': 'Transaction was cancelled',
        };
    }
  }

  Widget _buildTransactionDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactionColor = transaction.type == TransactionType.credit || 
                            transaction.type == TransactionType.refund
                          ? Colors.green
                          : Colors.red;
                          
    final amountPrefix = transaction.type == TransactionType.credit || 
                        transaction.type == TransactionType.refund
                      ? '+'
                      : '-';

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount and Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: transactionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: transaction.status),
              ],
            ),
            const Divider(height: 32),
            
            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Transaction ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ID',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.id,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: transaction.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction ID copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date & Time
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDateTime(transaction.date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // From / To Account
            Text(
              transaction.type == TransactionType.credit || transaction.type == TransactionType.refund
                  ? 'From'
                  : 'To',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  radius: 18,
                  child: Text(
                    transaction.recipientName.isNotEmpty 
                        ? transaction.recipientName[0].toUpperCase() 
                        : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.recipientName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (transaction.accountNumber.isNotEmpty)
                        Text(
                          transaction.accountNumber,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (transaction.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.notes,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            
            if (transaction.reference.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Reference',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.reference,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.receipt_long),
            label: const Text('Download Receipt'),
            onPressed: () {
              // Download receipt functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt downloading...')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share Details'),
            onPressed: () {
              // Share transaction details functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing transaction details...')),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          if (transaction.status == TransactionStatus.pending) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: const Text('Cancel Transaction', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Cancel transaction functionality
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cancel Transaction'),
                    content: const Text(
                      'Are you sure you want to cancel this transaction? This action cannot be undone.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No, Keep It'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Implement cancel transaction logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Transaction cancelled')),
                          );
                          Navigator.pop(context); // Return to the previous screen
                        },
                        child: const Text('Yes, Cancel It', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog or navigate to support
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Need Help?'),
                  content: const Text(
                    'If you have any questions about this transaction, please contact our support team.'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to support screen
                        Navigator.pushNamed(context, '/support');
                      },
                      child: const Text('Contact Support'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatusBar(context),
            _buildTransactionDetails(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }
}