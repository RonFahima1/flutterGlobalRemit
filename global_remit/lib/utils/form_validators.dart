class FormValidators {
  /// Validates that a field is not empty
  static String? required(String? value, [String message = 'This field is required']) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates an email address format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty email (optional field)
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a phone number format
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty phone (optional field)
    }
    
    final phoneRegExp = RegExp(
      r'^\+?[0-9\s\-\(\)]{8,20}$',
    );
    
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates a monetary amount
  static String? amount(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    
    // Check if it's a valid number
    final numericValue = double.tryParse(value.replaceAll(',', '.'));
    if (numericValue == null) {
      return 'Please enter a valid amount';
    }
    
    // Check minimum value
    if (min != null && numericValue < min) {
      return 'Amount must be at least ${min.toStringAsFixed(2)}';
    }
    
    // Check maximum value
    if (max != null && numericValue > max) {
      return 'Amount cannot exceed ${max.toStringAsFixed(2)}';
    }
    
    return null;
  }

  /// Validates text length
  static String? length(String? value, {int? min, int? max}) {
    if (value == null) {
      return null;
    }
    
    if (min != null && value.length < min) {
      return 'Must be at least $min characters';
    }
    
    if (max != null && value.length > max) {
      return 'Cannot exceed $max characters';
    }
    
    return null;
  }

  /// Validates that a password meets complexity requirements
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasNumbers = value.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (!hasUppercase || !hasLowercase || !hasNumbers || !hasSpecialCharacters) {
      return 'Password must include uppercase, lowercase, numbers, and special characters';
    }
    
    return null;
  }

  /// Validates that passwords match
  static String? passwordMatch(String? password, String? confirmPassword) {
    if (password == null || confirmPassword == null) {
      return null;
    }
    
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validates a date is within a range
  static String? date(DateTime? value, {DateTime? minDate, DateTime? maxDate}) {
    if (value == null) {
      return null;
    }
    
    if (minDate != null && value.isBefore(minDate)) {
      return 'Date must be after ${_formatDate(minDate)}';
    }
    
    if (maxDate != null && value.isAfter(maxDate)) {
      return 'Date must be before ${_formatDate(maxDate)}';
    }
    
    return null;
  }
  
  // Helper to format date for error messages
  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}