import 'package:intl/intl.dart';

/// Validates if a string is a valid currency amount
bool validateAmount(String value) {
  if (value.isEmpty) return true;
  
  // Check if the input matches a currency pattern
  // Allows numbers, one decimal point, and commas for thousand separators
  final RegExp regex = RegExp(r'^(\d{1,3}(,\d{3})*(\.\d{0,2})?|\.\d{1,2}|\d+(\.\d{0,2})?)$');
  return regex.hasMatch(value);
}

/// Format a numeric string with proper commas
String formatCurrency(String value) {
  if (value.isEmpty) return '0.00';
  
  try {
    final numericValue = double.parse(value.replaceAll(',', ''));
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(numericValue);
  } catch (e) {
    return value;
  }
}

/// Calculates the fee for a transaction
double calculateFee(double amount, double feePercentage, double minimumFee) {
  final calculatedFee = amount * (feePercentage / 100);
  return calculatedFee < minimumFee ? minimumFee : calculatedFee;
}

/// Get currency symbol from currency code
String getCurrencySymbol(String code) {
  final Map<String, String> symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'NGN': '₦',
    'GHS': '₵',
    'KES': 'KSh',
    'ZAR': 'R',
    'INR': '₹',
    'PHP': '₱',
    'MXN': '\$',
    'CAD': 'C\$',
    'AUD': 'A\$',
  };
  
  return symbols[code] ?? code;
}

/// Format a numeric value with proper commas and currency symbol
String formatWithCurrency(double value, String currencyCode) {
  final formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: getCurrencySymbol(currencyCode),
    decimalDigits: 2,
  );
  return formatter.format(value);
}

/// Convert a string value to a formatted currency string
String stringToCurrency(String value, String currencyCode) {
  if (value.isEmpty) return '${getCurrencySymbol(currencyCode)} 0.00';
  
  try {
    final numericValue = double.parse(value.replaceAll(',', ''));
    return formatWithCurrency(numericValue, currencyCode);
  } catch (e) {
    return '${getCurrencySymbol(currencyCode)} $value';
  }
}

/// Parse a currency string to a double value
double parseCurrencyToDouble(String value) {
  // Remove currency symbols and commas
  final cleanedValue = value.replaceAll(RegExp(r'[^\d.]'), '');
  
  try {
    return double.parse(cleanedValue);
  } catch (e) {
    return 0.0;
  }
}

/// Checks if a string is a valid IBAN
bool isValidIBAN(String iban) {
  // Remove spaces and convert to uppercase
  iban = iban.replaceAll(' ', '').toUpperCase();
  
  // Basic format check
  final RegExp regex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$');
  if (!regex.hasMatch(iban)) return false;
  
  // Move the first 4 characters to the end
  final String rearranged = iban.substring(4) + iban.substring(0, 4);
  
  // Convert letters to numbers (A=10, B=11, ..., Z=35)
  String digits = '';
  for (int i = 0; i < rearranged.length; i++) {
    final int charCode = rearranged.codeUnitAt(i);
    if (charCode >= 48 && charCode <= 57) {
      // It's a digit
      digits += rearranged[i];
    } else {
      // It's a letter
      digits += (charCode - 55).toString();
    }
  }
  
  // Calculate the mod 97 and verify it equals 1
  // (Simplified calculation since the full calculation can exceed integer limits)
  int remainder = 0;
  for (int i = 0; i < digits.length; i++) {
    remainder = (remainder * 10 + int.parse(digits[i])) % 97;
  }
  
  return remainder == 1;
}
