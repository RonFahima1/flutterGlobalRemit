import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', transaction.date.toLocal().toString().split('.')[0]),
            _buildDetailRow('Description', transaction.description),
            _buildDetailRow('Amount', '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Type', transaction.type.toString().split('.').last),
            if (transaction.note != null) _buildDetailRow('Note', transaction.note!),
            if (transaction.fee != null) _buildDetailRow('Fee', '${transaction.currency} ${transaction.fee?.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Date', transaction.date.toString()),
                    _buildDetailRow('Status', 'Completed'),
                    _buildDetailRow('Reference', transaction.id),
                    if (transaction.note != null)
                      _buildDetailRow('Note', transaction.note!),
                    if (transaction.fee != null)
                      _buildDetailRow('Fee', '${transaction.currency} ${transaction.fee}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
