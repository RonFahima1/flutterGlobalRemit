import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback? onSeeAllTap;

  const TransactionList({
    super.key, 
    required this.transactions,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions yet.'),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
        final transaction = transactions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  _getIconForTransactionType(transaction.type),
                  color: transaction.type == TransactionType.SEND
                      ? Colors.red
                      : Colors.green,
                ),
                title: Text(transaction.description),
                subtitle: Text(
                  DateFormat('MMM d, yyyy').format(transaction.date),
                ),
                trailing: Text(
                  '${transaction.type == TransactionType.RECEIVE ? '+' : '-'} ${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: transaction.type == TransactionType.SEND
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Navigate to transaction details
                  Navigator.pushNamed(
                    context,
                    '/transaction/${transaction.id}',
                  );
                },
              ),
            );
          },
        ),
        if (onSeeAllTap != null)
          TextButton(
            onPressed: onSeeAllTap,
            child: const Text('See all transactions'),
          ),
      ],
    );
  }

  IconData _getIconForTransactionType(TransactionType type) {
    switch (type) {
      case TransactionType.SEND:
        return Icons.arrow_upward;
      case TransactionType.RECEIVE:
        return Icons.arrow_downward;
      default:
        return Icons.swap_horiz;
    }
  }
}
