import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Sample transactions (in a real app, this would come from a provider)
    final List<Transaction> transactions = [
      Transaction(
        id: '1',
        recipientName: 'Maria Rodriguez',
        recipientCountry: 'Mexico',
        amount: 250.00,
        fee: 3.99,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '2',
        recipientName: 'Carlos Gomez',
        recipientCountry: 'Colombia',
        amount: 350.00,
        fee: 4.99,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '3',
        recipientName: 'Wei Chen',
        recipientCountry: 'China',
        amount: 500.00,
        fee: 6.99,
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '4',
        recipientName: 'Priya Patel',
        recipientCountry: 'India',
        amount: 200.00,
        fee: 2.99,
        date: DateTime.now().subtract(const Duration(days: 14)),
        status: TransactionStatus.failed,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Render transactions based on platform style
            if (PlatformUtils.isIOS) 
              _buildCupertinoList(context, transactions)
            else
              _buildMaterialList(context, transactions),
              
            // View all button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white10 : Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'View All Transactions',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialList(BuildContext context, List<Transaction> transactions) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: isDark ? Colors.white10 : Colors.black12,
      ),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final dateFormatter = DateFormat('MMM dd, yyyy');
        
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: _buildCountryAvatar(transaction.recipientCountry),
          title: Text(
            transaction.recipientName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${dateFormatter.format(transaction.date)} • ${transaction.recipientCountry}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.status == TransactionStatus.completed
                      ? isDark ? Colors.white : Colors.black
                      : theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.status == TransactionStatus.completed ? 'Completed' : 'Failed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: transaction.status == TransactionStatus.completed
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
              ),
            ],
          ),
          onTap: () {
            // Handle tapping on a transaction
          },
        );
      },
    );
  }

  Widget _buildCupertinoList(BuildContext context, List<Transaction> transactions) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: isDark ? CupertinoColors.systemGrey5.darkColor : CupertinoColors.systemGrey5,
        margin: const EdgeInsets.only(left: 70),
      ),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final dateFormatter = DateFormat('MMM dd, yyyy');
        
        return CupertinoListTile(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: _buildCountryAvatar(transaction.recipientCountry),
          title: Text(
            transaction.recipientName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? CupertinoColors.white : CupertinoColors.black,
            ),
          ),
          subtitle: Text(
            '${dateFormatter.format(transaction.date)} • ${transaction.recipientCountry}',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction.status == TransactionStatus.completed
                      ? isDark ? CupertinoColors.white : CupertinoColors.black
                      : CupertinoColors.systemRed,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.status == TransactionStatus.completed ? 'Completed' : 'Failed',
                style: TextStyle(
                  fontSize: 13,
                  color: transaction.status == TransactionStatus.completed
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.systemRed,
                ),
              ),
            ],
          ),
          onTap: () {
            // Handle tapping on a transaction
          },
        );
      },
    );
  }

  Widget _buildCountryAvatar(String country) {
    // In a real app, you'd have proper flag assets
    final flagEmoji = _getCountryFlagEmoji(country);
    
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _getCountryColor(country),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          flagEmoji,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  String _getCountryFlagEmoji(String country) {
    // Simple mapping of country to emoji flag
    switch (country) {
      case 'Mexico':
        return '🇲🇽';
      case 'Colombia':
        return '🇨🇴';
      case 'China':
        return '🇨🇳';
      case 'India':
        return '🇮🇳';
      default:
        return '🌍';
    }
  }

  Color _getCountryColor(String country) {
    // Simple mapping of country to color
    switch (country) {
      case 'Mexico':
        return Colors.green[100]!;
      case 'Colombia':
        return Colors.yellow[100]!;
      case 'China':
        return Colors.red[100]!;
      case 'India':
        return Colors.orange[100]!;
      default:
        return Colors.blue[100]!;
    }
  }
}