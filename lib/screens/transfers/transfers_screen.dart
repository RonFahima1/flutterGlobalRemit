import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/platform_utils.dart';
import '../../widgets/platform_text_field.dart';
import '../../widgets/platform_button.dart';
import '../../widgets/platform_card.dart';
import '../../models/transaction.dart';
import '../../widgets/recent_transactions_list.dart';
import 'package:intl/intl.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _accountController = TextEditingController();
  String _selectedCountry = 'Mexico';
  String _selectedCurrency = 'MXN';
  bool _isLoading = false;
  
  final List<Map<String, String>> _countries = [
    {'name': 'Mexico', 'code': 'MX', 'currency': 'MXN'},
    {'name': 'Colombia', 'code': 'CO', 'currency': 'COP'},
    {'name': 'India', 'code': 'IN', 'currency': 'INR'},
    {'name': 'China', 'code': 'CN', 'currency': 'CNY'},
    {'name': 'Philippines', 'code': 'PH', 'currency': 'PHP'},
  ];
  
  // Exchange rates (in a real app, this would come from an API)
  final Map<String, double> _exchangeRates = {
    'MXN': 17.24,
    'COP': 3982.50,
    'INR': 83.12,
    'CNY': 7.21,
    'PHP': 56.43,
  };

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  // Calculate fee based on amount (simplified for demo)
  double _calculateFee(double amount) {
    if (amount <= 0) return 0;
    if (amount < 300) return 3.99;
    if (amount < 500) return 5.99;
    return 7.99;
  }
  
  // Calculate equivalent amount in destination currency
  String _calculateEquivalentAmount() {
    if (_amountController.text.isEmpty) return '';
    
    try {
      final amount = double.parse(_amountController.text);
      final exchangeRate = _exchangeRates[_selectedCurrency] ?? 1.0;
      final equivalentAmount = amount * exchangeRate;
      
      // Format with currency code
      return NumberFormat.currency(
        symbol: '',
        decimalDigits: 2,
      ).format(equivalentAmount) + ' ' + _selectedCurrency;
    } catch (e) {
      return '';
    }
  }
  
  // Show country picker
  void _showCountryPicker() {
    if (PlatformUtils.isIOS) {
      _showCupertinoCountryPicker();
    } else {
      _showMaterialCountryPicker();
    }
  }
  
  // Cupertino style country picker
  void _showCupertinoCountryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: CupertinoColors.systemGrey5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                children: _countries.map((country) {
                  return Center(
                    child: Text(
                      '${country['name']} (${country['currency']})',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedCountry = _countries[index]['name']!;
                    _selectedCurrency = _countries[index]['currency']!;
                  });
                },
                scrollController: FixedExtentScrollController(
                  initialItem: _countries.indexWhere(
                    (country) => country['name'] == _selectedCountry
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Material style country picker
  void _showMaterialCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Select Country',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                final isSelected = country['name'] == _selectedCountry;
                
                return ListTile(
                  title: Text(country['name']!),
                  subtitle: Text('Currency: ${country['currency']}'),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCountry = country['name']!;
                      _selectedCurrency = country['currency']!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Process transfer
  Future<void> _processTransfer() async {
    // Validate fields
    if (_amountController.text.isEmpty ||
        _recipientController.text.isEmpty ||
        _accountController.text.isEmpty) {
      // Show error
      if (PlatformUtils.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Missing Information'),
            content: const Text('Please fill in all required fields.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }
    
    // Start loading
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Show success
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      if (PlatformUtils.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Transfer Initiated'),
            content: const Text(
              'Your money transfer has been initiated successfully. '
              'You will receive a confirmation shortly.',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Reset form
                  _amountController.clear();
                  _recipientController.clear();
                  _accountController.clear();
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Transfer Initiated'),
            content: const Text(
              'Your money transfer has been initiated successfully. '
              'You will receive a confirmation shortly.',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Reset form
                  _amountController.clear();
                  _recipientController.clear();
                  _accountController.clear();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = PlatformUtils.isIOS;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Send Money',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fill the form below to send money internationally',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          
          // Transfer form
          PlatformCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount field
                PlatformTextField(
                  controller: _amountController,
                  label: 'Amount to Send (USD)',
                  placeholder: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.attach_money,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                
                // Country selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isIOS)
                      Text(
                        'Destination Country',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (!isIOS)
                      const SizedBox(height: 8),
                    InkWell(
                      onTap: _showCountryPicker,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark 
                                ? Colors.white.withOpacity(0.2) 
                                : Colors.black.withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _getCountryFlagEmoji(_selectedCountry),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedCountry,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Currency: $_selectedCurrency',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isIOS 
                                  ? CupertinoIcons.chevron_down 
                                  : Icons.arrow_drop_down,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Recipient name
                PlatformTextField(
                  controller: _recipientController,
                  label: 'Recipient\'s Name',
                  placeholder: 'Full name of the recipient',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                
                // Account number
                PlatformTextField(
                  controller: _accountController,
                  label: 'Account Number',
                  placeholder: 'Recipient\'s account number',
                  prefixIcon: Icons.account_balance,
                ),
                const SizedBox(height: 24),
                
                // Summary
                if (_amountController.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.white.withOpacity(0.05) 
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You Send',
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              '\$${_amountController.text}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fee',
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              '\$${_calculateFee(double.tryParse(_amountController.text) ?? 0).toStringAsFixed(2)}',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exchange Rate',
                              style: theme.textTheme.bodyLarge,
                            ),
                            Text(
                              '1 USD = ${_exchangeRates[_selectedCurrency]?.toStringAsFixed(2) ?? '1.00'} $_selectedCurrency',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recipient Gets',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _calculateEquivalentAmount(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Submit button
                PlatformButton(
                  text: 'Send Money',
                  onPressed: _processTransfer,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  variant: ButtonVariant.primary,
                  size: ButtonSize.large,
                  leadingIcon: Icons.send,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Recent transfers
          Text(
            'Recent Transfers',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          const RecentTransactionsList(),
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
      case 'India':
        return '🇮🇳';
      case 'China':
        return '🇨🇳';
      case 'Philippines':
        return '🇵🇭';
      default:
        return '🌍';
    }
  }
}