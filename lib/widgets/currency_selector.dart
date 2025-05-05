import 'package:flutter/material.dart';
import '../models/currency.dart';

class CurrencySelector extends StatelessWidget {
  final Currency selectedCurrency;
  final Function(Currency) onCurrencySelected;

  const CurrencySelector({
    Key? key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCurrencyPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(
              selectedCurrency.code,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CurrencyPickerSheet(
        selectedCurrency: selectedCurrency,
        onCurrencySelected: (currency) {
          Navigator.pop(context);
          onCurrencySelected(currency);
        },
      ),
    );
  }
}

class CurrencyPickerSheet extends StatefulWidget {
  final Currency selectedCurrency;
  final Function(Currency) onCurrencySelected;

  const CurrencyPickerSheet({
    Key? key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  }) : super(key: key);

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  late TextEditingController _searchController;
  List<Currency> _filteredCurrencies = [];

  // Available currencies
  final List<Currency> _currencies = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    Currency(code: 'EUR', symbol: '€', name: 'Euro'),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    Currency(code: 'NGN', symbol: '₦', name: 'Nigerian Naira'),
    Currency(code: 'GHS', symbol: '₵', name: 'Ghanaian Cedi'),
    Currency(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCurrencies = List.from(_currencies);
    _searchController.addListener(_filterCurrencies);
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = List.from(_currencies);
      } else {
        _filteredCurrencies = _currencies.where((currency) {
          return currency.name.toLowerCase().contains(query) ||
              currency.code.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Search box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currencies',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          
          // Currency list
          Flexible(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                final isSelected = currency.code == widget.selectedCurrency.code;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      currency.symbol,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  title: Text(
                    currency.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(currency.name),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0066CC),
                        )
                      : null,
                  tileColor: isSelected ? const Color(0xFFF0F7FF) : null,
                  onTap: () => widget.onCurrencySelected(currency),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}