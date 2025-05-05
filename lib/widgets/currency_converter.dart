import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';
import 'platform_text_field.dart';
import 'platform_card.dart';
import 'platform_button.dart';
import 'package:intl/intl.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final _fromAmountController = TextEditingController();
  final _toAmountController = TextEditingController();
  
  String _fromCurrency = 'USD';
  String _toCurrency = 'MXN';
  
  bool _isSwapping = false;
  
  // List of available currencies with their symbols
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'symbol': '\$'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': '\$'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': '\$'},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
    {'code': 'BRL', 'name': 'Brazilian Real', 'symbol': 'R\$'},
  ];
  
  // Exchange rates (in a real app, this would come from an API)
  final Map<String, Map<String, double>> _exchangeRates = {
    'USD': {
      'EUR': 0.92,
      'GBP': 0.78,
      'JPY': 150.45,
      'MXN': 17.24,
      'CAD': 1.35,
      'AUD': 1.48,
      'INR': 83.12,
      'CNY': 7.21,
      'BRL': 5.05,
    },
    'EUR': {
      'USD': 1.09,
      'GBP': 0.85,
      'JPY': 164.02,
      'MXN': 18.79,
      'CAD': 1.47,
      'AUD': 1.61,
      'INR': 90.60,
      'CNY': 7.86,
      'BRL': 5.51,
    },
    // Add more as needed - in real app would use a complete matrix or API
  };

  @override
  void initState() {
    super.initState();
    _fromAmountController.text = '100.00';
    _calculateExchange(isFrom: true);
  }

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }
  
  // Calculate exchange rate
  double _getExchangeRate() {
    // If same currency, rate is 1
    if (_fromCurrency == _toCurrency) return 1.0;
    
    // Direct lookup
    if (_exchangeRates.containsKey(_fromCurrency) && 
        _exchangeRates[_fromCurrency]!.containsKey(_toCurrency)) {
      return _exchangeRates[_fromCurrency]![_toCurrency]!;
    }
    
    // Inverse lookup
    if (_exchangeRates.containsKey(_toCurrency) && 
        _exchangeRates[_toCurrency]!.containsKey(_fromCurrency)) {
      return 1 / _exchangeRates[_toCurrency]![_fromCurrency]!;
    }
    
    // Use USD as intermediary
    if (_fromCurrency != 'USD' && _toCurrency != 'USD') {
      final fromToUsd = _exchangeRates.containsKey('USD') && 
                       _exchangeRates['USD']!.containsKey(_fromCurrency)
                       ? 1 / _exchangeRates['USD']![_fromCurrency]!
                       : (_exchangeRates.containsKey(_fromCurrency) && 
                          _exchangeRates[_fromCurrency]!.containsKey('USD')
                          ? _exchangeRates[_fromCurrency]!['USD']!
                          : 1.0);
      
      final usdToTo = _exchangeRates.containsKey('USD') && 
                     _exchangeRates['USD']!.containsKey(_toCurrency)
                     ? _exchangeRates['USD']![_toCurrency]!
                     : (_exchangeRates.containsKey(_toCurrency) && 
                        _exchangeRates[_toCurrency]!.containsKey('USD')
                        ? 1 / _exchangeRates[_toCurrency]!['USD']!
                        : 1.0);
      
      return fromToUsd * usdToTo;
    }
    
    // Default if no rate found
    return 1.0;
  }
  
  // Calculate exchange amount
  void _calculateExchange({required bool isFrom}) {
    try {
      final rate = _getExchangeRate();
      
      if (isFrom) {
        // Calculate to amount based on from amount
        if (_fromAmountController.text.isEmpty) {
          _toAmountController.text = '';
          return;
        }
        
        final fromAmount = double.parse(_fromAmountController.text);
        final toAmount = fromAmount * rate;
        
        _toAmountController.text = toAmount.toStringAsFixed(2);
      } else {
        // Calculate from amount based on to amount
        if (_toAmountController.text.isEmpty) {
          _fromAmountController.text = '';
          return;
        }
        
        final toAmount = double.parse(_toAmountController.text);
        final fromAmount = toAmount / rate;
        
        _fromAmountController.text = fromAmount.toStringAsFixed(2);
      }
    } catch (e) {
      // Handle parsing error
    }
  }
  
  // Swap currencies
  void _swapCurrencies() {
    setState(() {
      _isSwapping = true;
    });
    
    // Swap currencies
    final tempCurrency = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = tempCurrency;
    
    // Swap amounts
    final tempAmount = _fromAmountController.text;
    _fromAmountController.text = _toAmountController.text;
    _toAmountController.text = tempAmount;
    
    // Animation delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isSwapping = false;
        });
      }
    });
  }
  
  // Show currency selector
  void _showCurrencySelector(bool isFrom) {
    if (PlatformUtils.isIOS) {
      _showCupertinoCurrencySelector(isFrom);
    } else {
      _showMaterialCurrencySelector(isFrom);
    }
  }
  
  // Cupertino style currency selector
  void _showCupertinoCurrencySelector(bool isFrom) {
    final currentCurrency = isFrom ? _fromCurrency : _toCurrency;
    
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
                children: _currencies.map((currency) {
                  return Center(
                    child: Text(
                      '${currency['code']} - ${currency['name']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    if (isFrom) {
                      _fromCurrency = _currencies[index]['code']!;
                    } else {
                      _toCurrency = _currencies[index]['code']!;
                    }
                    _calculateExchange(isFrom: true);
                  });
                },
                scrollController: FixedExtentScrollController(
                  initialItem: _currencies.indexWhere(
                    (currency) => currency['code'] == currentCurrency
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Material style currency selector
  void _showMaterialCurrencySelector(bool isFrom) {
    final currentCurrency = isFrom ? _fromCurrency : _toCurrency;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Select Currency',
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
            Expanded(
              child: ListView.builder(
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  final isSelected = currency['code'] == currentCurrency;
                  
                  return ListTile(
                    title: Text('${currency['code']} - ${currency['name']}'),
                    subtitle: Text('Symbol: ${currency['symbol']}'),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isFrom) {
                          _fromCurrency = currency['code']!;
                        } else {
                          _toCurrency = currency['code']!;
                        }
                        _calculateExchange(isFrom: true);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rate = _getExchangeRate();
    
    return PlatformCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Text(
            'Currency Converter',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Convert between different currencies',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          
          // From currency
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currency selector
              GestureDetector(
                onTap: () => _showCurrencySelector(true),
                child: Container(
                  width: 90,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.white30 : Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _fromCurrency,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Amount input
              Expanded(
                child: PlatformTextField(
                  controller: _fromAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  placeholder: 'Amount',
                  onChanged: (_) => _calculateExchange(isFrom: true),
                ),
              ),
            ],
          ),
          
          // Swap button
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: AnimatedRotation(
                  turns: _isSwapping ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.swap_vert,
                    color: theme.colorScheme.primary,
                  ),
                ),
                onPressed: _swapCurrencies,
              ),
            ),
          ),
          
          // To currency
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currency selector
              GestureDetector(
                onTap: () => _showCurrencySelector(false),
                child: Container(
                  width: 90,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.white30 : Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _toCurrency,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Amount input
              Expanded(
                child: PlatformTextField(
                  controller: _toAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  placeholder: 'Amount',
                  onChanged: (_) => _calculateExchange(isFrom: false),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Exchange rate info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1 $_fromCurrency = ${rate.toStringAsFixed(4)} $_toCurrency',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Convert button
          PlatformButton(
            text: 'Send Money',
            variant: ButtonVariant.primary,
            isFullWidth: true,
            onPressed: () {
              // Navigate to transfer screen with pre-filled values
              // In a real app, this would pass the values to the transfer screen
            },
          ),
        ],
      ),
    );
  }
}