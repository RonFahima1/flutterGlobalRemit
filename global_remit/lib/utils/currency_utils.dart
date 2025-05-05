import 'package:intl/intl.dart';

/// Formats a currency amount with the appropriate currency symbol
String formatCurrency(double amount, String currencyCode, {bool compact = false}) {
  final symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'CA\$',
    'AUD': 'A\$',
    'CNY': '¥',
    'INR': '₹',
    'BRL': 'R\$',
    'MXN': 'MX\$',
    'AED': 'د.إ',
    'SAR': '﷼',
    'SGD': 'S\$',
    'NGN': '₦',
    'KES': 'KSh',
  };

  final decimalDigits = _getDecimalDigits(currencyCode);
  
  try {
    if (compact) {
      final compactFormat = NumberFormat.compactCurrency(
        symbol: symbols[currencyCode] ?? currencyCode,
        decimalDigits: 1,
      );
      return compactFormat.format(amount);
    } else {
      final format = NumberFormat.currency(
        symbol: symbols[currencyCode] ?? currencyCode,
        decimalDigits: decimalDigits,
      );
      return format.format(amount);
    }
  } catch (e) {
    // Fallback if there's any error with the formatter
    final symbol = symbols[currencyCode] ?? currencyCode;
    final formattedAmount = amount.toStringAsFixed(decimalDigits);
    return '$symbol$formattedAmount';
  }
}

/// Gets the appropriate number of decimal digits for a currency
int _getDecimalDigits(String currencyCode) {
  final noDecimalCurrencies = ['JPY', 'KRW', 'TWD', 'HUF', 'CLP'];
  if (noDecimalCurrencies.contains(currencyCode)) {
    return 0;
  }
  return 2; // Most currencies use 2 decimal places
}

/// Returns the appropriate currency symbol for a currency code
String getCurrencySymbol(String currencyCode) {
  final symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'CA\$',
    'AUD': 'A\$',
    'CNY': '¥',
    'INR': '₹',
    'BRL': 'R\$',
    'MXN': 'MX\$',
    'AED': 'د.إ',
    'SAR': '﷼',
    'SGD': 'S\$',
    'NGN': '₦',
    'KES': 'KSh',
  };
  
  return symbols[currencyCode] ?? currencyCode;
}

/// Formats a money transfer amount with fees included
String formatTransferAmount(double amount, double? fee, String currencyCode) {
  final totalAmount = amount + (fee ?? 0);
  return formatCurrency(totalAmount, currencyCode);
}

/// Formats an exchange rate between two currencies
String formatExchangeRate(double rate, String fromCurrency, String toCurrency) {
  final formatter = NumberFormat('#,##0.0000', 'en_US');
  return '1 $fromCurrency = ${formatter.format(rate)} $toCurrency';
}

/// Calculates the received amount after conversion
double calculateReceivedAmount(double sendAmount, double exchangeRate, double? fee) {
  return (sendAmount - (fee ?? 0)) * exchangeRate;
}

/// Formats a received amount with the converted currency
String formatReceivedAmount(double sendAmount, double exchangeRate, double? fee, String toCurrency) {
  final receivedAmount = calculateReceivedAmount(sendAmount, exchangeRate, fee);
  return formatCurrency(receivedAmount, toCurrency);
}

/// Returns a list of commonly used currencies
List<Map<String, String>> getCommonCurrencies() {
  return [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'CA\$'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
    {'code': 'BRL', 'name': 'Brazilian Real', 'symbol': 'R\$'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'symbol': 'MX\$'},
    {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'د.إ'},
    {'code': 'SAR', 'name': 'Saudi Riyal', 'symbol': '﷼'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'symbol': 'S\$'},
    {'code': 'NGN', 'name': 'Nigerian Naira', 'symbol': '₦'},
    {'code': 'KES', 'name': 'Kenyan Shilling', 'symbol': 'KSh'},
  ];
}