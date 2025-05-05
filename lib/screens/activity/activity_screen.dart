import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/platform_utils.dart';
import '../../models/transaction.dart';
import '../../widgets/platform_card.dart';
import '../../widgets/platform_button.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Filter options
  String _selectedPeriod = 'All';
  String _selectedStatus = 'All';
  
  // List of sample transactions
  final List<Transaction> _transactions = [
    Transaction(
      id: '1001',
      recipientName: 'Maria Rodriguez',
      recipientCountry: 'Mexico',
      amount: 250.00,
      fee: 3.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025436',
      description: 'Monthly support',
    ),
    Transaction(
      id: '1002',
      recipientName: 'Carlos Gomez',
      recipientCountry: 'Colombia',
      amount: 350.00,
      fee: 4.99,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025437',
      description: 'Family assistance',
    ),
    Transaction(
      id: '1003',
      recipientName: 'Wei Chen',
      recipientCountry: 'China',
      amount: 500.00,
      fee: 6.99,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025438',
      description: 'Business payment',
    ),
    Transaction(
      id: '1004',
      recipientName: 'Priya Patel',
      recipientCountry: 'India',
      amount: 200.00,
      fee: 2.99,
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: TransactionStatus.failed,
      referenceNumber: 'TR-10025439',
      description: 'School fees',
    ),
    Transaction(
      id: '1005',
      recipientName: 'Juan Lopez',
      recipientCountry: 'Mexico',
      amount: 180.00,
      fee: 2.99,
      date: DateTime.now().subtract(const Duration(days: 18)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025440',
      description: 'Rent payment',
    ),
    Transaction(
      id: '1006',
      recipientName: 'Sofia Martinez',
      recipientCountry: 'Colombia',
      amount: 275.00,
      fee: 3.99,
      date: DateTime.now().subtract(const Duration(days: 25)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025441',
      description: 'Medical expenses',
    ),
    Transaction(
      id: '1007',
      recipientName: 'Maria Rodriguez',
      recipientCountry: 'Mexico',
      amount: 250.00,
      fee: 3.99,
      date: DateTime.now().subtract(const Duration(days: 35)),
      status: TransactionStatus.completed,
      referenceNumber: 'TR-10025442',
      description: 'Monthly support',
    ),
    Transaction(
      id: '1008',
      recipientName: 'Ahmed Hassan',
      recipientCountry: 'Egypt',
      amount: 300.00,
      fee: 3.99,
      date: DateTime.now().subtract(const Duration(days: 40)),
      status: TransactionStatus.pending,
      referenceNumber: 'TR-10025443',
      description: 'Family support',
    ),
  ];

  // Filtered transactions
  List<Transaction> get filteredTransactions {
    List<Transaction> result = List.from(_transactions);
    
    // Filter by period
    if (_selectedPeriod != 'All') {
      final now = DateTime.now();
      switch (_selectedPeriod) {
        case 'Last 7 days':
          result = result.where((t) => 
            t.date.isAfter(now.subtract(const Duration(days: 7)))
          ).toList();
          break;
        case 'Last 30 days':
          result = result.where((t) => 
            t.date.isAfter(now.subtract(const Duration(days: 30)))
          ).toList();
          break;
        case 'Last 90 days':
          result = result.where((t) => 
            t.date.isAfter(now.subtract(const Duration(days: 90)))
          ).toList();
          break;
      }
    }
    
    // Filter by status
    if (_selectedStatus != 'All') {
      final status = TransactionStatus.values.firstWhere(
        (s) => s.toString().split('.').last == _selectedStatus.toLowerCase(),
        orElse: () => TransactionStatus.completed,
      );
      result = result.where((t) => t.status == status).toList();
    }
    
    // Sort by date (newest first)
    result.sort((a, b) => b.date.compareTo(a.date));
    
    return result;
  }
  
  void _showFilterDialog() {
    if (PlatformUtils.isIOS) {
      _showCupertinoFilterDialog();
    } else {
      _showMaterialFilterDialog();
    }
  }
  
  void _showCupertinoFilterDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Filter Transactions'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showCupertinoFilterOptions(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time Period'),
                Text(
                  _selectedPeriod,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showCupertinoFilterOptions(false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                Text(
                  _selectedStatus,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
          isDestructiveAction: true,
        ),
      ),
    );
  }
  
  void _showCupertinoFilterOptions(bool isPeriod) {
    final options = isPeriod
        ? ['All', 'Last 7 days', 'Last 30 days', 'Last 90 days']
        : ['All', 'Completed', 'Pending', 'Failed'];
    
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Select ${isPeriod ? 'Time Period' : 'Status'}'),
        actions: options.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                if (isPeriod) {
                  _selectedPeriod = option;
                } else {
                  _selectedStatus = option;
                }
              });
              Navigator.pop(context);
            },
            child: Text(option),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
          isDestructiveAction: true,
        ),
      ),
    );
  }
  
  void _showMaterialFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Time Period'),
              subtitle: Text(_selectedPeriod),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
                _showMaterialFilterOptions(true);
              },
            ),
            ListTile(
              title: const Text('Status'),
              subtitle: Text(_selectedStatus),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
                _showMaterialFilterOptions(false);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedPeriod = 'All';
                _selectedStatus = 'All';
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _showMaterialFilterOptions(bool isPeriod) {
    final options = isPeriod
        ? ['All', 'Last 7 days', 'Last 30 days', 'Last 90 days']
        : ['All', 'Completed', 'Pending', 'Failed'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${isPeriod ? 'Time Period' : 'Status'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = isPeriod
                  ? _selectedPeriod == option
                  : _selectedStatus == option;
              
              return ListTile(
                title: Text(option),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    if (isPeriod) {
                      _selectedPeriod = option;
                    } else {
                      _selectedStatus = option;
                    }
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _viewTransactionDetails(Transaction transaction) {
    if (PlatformUtils.isIOS) {
      _showCupertinoTransactionDetails(transaction);
    } else {
      _showMaterialTransactionDetails(transaction);
    }
  }
  
  void _showCupertinoTransactionDetails(Transaction transaction) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Transaction Details'),
        message: Column(
          children: [
            _buildTransactionDetailRow('Recipient', transaction.recipientName),
            _buildTransactionDetailRow('Country', transaction.recipientCountry),
            _buildTransactionDetailRow('Amount', '\$${transaction.amount.toStringAsFixed(2)}'),
            _buildTransactionDetailRow('Fee', '\$${transaction.fee.toStringAsFixed(2)}'),
            _buildTransactionDetailRow('Total', '\$${transaction.totalAmount.toStringAsFixed(2)}'),
            _buildTransactionDetailRow('Date', DateFormat('MMM dd, yyyy').format(transaction.date)),
            _buildTransactionDetailRow('Status', transaction.statusText),
            if (transaction.referenceNumber != null)
              _buildTransactionDetailRow('Reference', transaction.referenceNumber!),
            if (transaction.description != null)
              _buildTransactionDetailRow('Description', transaction.description!),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              // In a real app, this would download the receipt
              Navigator.pop(context);
            },
            child: const Text('Download Receipt'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // In a real app, this would repeat the transaction
              Navigator.pop(context);
            },
            child: const Text('Repeat Transaction'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
          isDefaultAction: true,
        ),
      ),
    );
  }
  
  Widget _buildTransactionDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showMaterialTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMaterialDetailItem('Recipient', transaction.recipientName),
              _buildMaterialDetailItem('Country', transaction.recipientCountry),
              _buildMaterialDetailItem('Amount', '\$${transaction.amount.toStringAsFixed(2)}'),
              _buildMaterialDetailItem('Fee', '\$${transaction.fee.toStringAsFixed(2)}'),
              _buildMaterialDetailItem('Total', '\$${transaction.totalAmount.toStringAsFixed(2)}'),
              _buildMaterialDetailItem('Date', DateFormat('MMM dd, yyyy').format(transaction.date)),
              _buildMaterialDetailItem('Status', transaction.statusText),
              if (transaction.referenceNumber != null)
                _buildMaterialDetailItem('Reference', transaction.referenceNumber!),
              if (transaction.description != null)
                _buildMaterialDetailItem('Description', transaction.description!),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Receipt'),
                    onPressed: () {
                      // Download receipt functionality
                      Navigator.pop(context);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.repeat),
                    label: const Text('Repeat'),
                    onPressed: () {
                      // Repeat transaction functionality
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMaterialDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = PlatformUtils.isIOS;
    final transactions = filteredTransactions;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Transaction History',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'View and manage your transaction history',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          
          // Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions (${transactions.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              PlatformButton(
                text: 'Filter',
                variant: ButtonVariant.outlined,
                size: ButtonSize.small,
                leadingIcon: isIOS ? CupertinoIcons.slider_horizontal_3 : Icons.filter_list,
                onPressed: _showFilterDialog,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Active filters
          if (_selectedPeriod != 'All' || _selectedStatus != 'All') ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_selectedPeriod != 'All')
                  _buildFilterChip(
                    _selectedPeriod,
                    onRemove: () => setState(() => _selectedPeriod = 'All'),
                  ),
                if (_selectedStatus != 'All')
                  _buildFilterChip(
                    _selectedStatus,
                    onRemove: () => setState(() => _selectedStatus = 'All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Transactions list
          if (transactions.isEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: PlatformCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isIOS ? CupertinoIcons.doc_text_search : Icons.search_off,
                      size: 48,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions found',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try changing your filters',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionCard(transaction);
              },
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, {required VoidCallback onRemove}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = PlatformUtils.isIOS;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              isIOS ? CupertinoIcons.xmark_circle_fill : Icons.cancel,
              size: 18,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionCard(Transaction transaction) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = PlatformUtils.isIOS;
    final dateFormatter = DateFormat('MMM dd, yyyy');
    
    Color statusColor;
    switch (transaction.status) {
      case TransactionStatus.completed:
        statusColor = Colors.green;
        break;
      case TransactionStatus.pending:
        statusColor = Colors.orange;
        break;
      case TransactionStatus.failed:
        statusColor = theme.colorScheme.error;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return PlatformCard(
      variant: CardVariant.outlined,
      onTap: () => _viewTransactionDetails(transaction),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Country flag
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCountryColor(transaction.recipientCountry),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getCountryFlagEmoji(transaction.recipientCountry),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Recipient info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.recipientName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${dateFormatter.format(transaction.date)} • ${transaction.recipientCountry}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Amount info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction.status.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          if (transaction.description != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              transaction.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fee: \$${transaction.fee.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Text(
                'Ref: ${transaction.referenceNumber ?? 'N/A'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ],
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
      case 'Egypt':
        return '🇪🇬';
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
      case 'Egypt':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}