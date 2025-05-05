import 'dart:convert';
import '../models/currency.dart';
import '../models/transfer_method.dart';
import 'package:flutter/material.dart';

/// Service to handle country-specific data and options for international transfers
class CountryService {
  /// Get available currencies for a specific country
  Future<List<Currency>> getAvailableCurrencies(String countryCode) async {
    // In a real app, this would be an API call
    // Simulating API response for development
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Country-specific currencies
    final Map<String, List<Map<String, dynamic>>> countryCurrencies = {
      'NG': [
        {'code': 'NGN', 'symbol': '₦', 'name': 'Nigerian Naira'},
      ],
      'GH': [
        {'code': 'GHS', 'symbol': '₵', 'name': 'Ghanaian Cedi'},
      ],
      'KE': [
        {'code': 'KES', 'symbol': 'KSh', 'name': 'Kenyan Shilling'},
      ],
      'ZA': [
        {'code': 'ZAR', 'symbol': 'R', 'name': 'South African Rand'},
      ],
      'IN': [
        {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      ],
      'MX': [
        {'code': 'MXN', 'symbol': '$', 'name': 'Mexican Peso'},
      ],
      'PH': [
        {'code': 'PHP', 'symbol': '₱', 'name': 'Philippine Peso'},
      ],
      'GB': [
        {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      ],
      'EU': [
        {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      ],
      'CA': [
        {'code': 'CAD', 'symbol': 'C$', 'name': 'Canadian Dollar'},
      ],
      'AU': [
        {'code': 'AUD', 'symbol': 'A$', 'name': 'Australian Dollar'},
      ],
    };
    
    // Default currencies for countries not in the list
    final defaultCurrencies = [
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    ];
    
    final currencyList = countryCurrencies[countryCode] ?? defaultCurrencies;
    
    return currencyList.map((json) => Currency.fromJson(json)).toList();
  }
  
  /// Get available transfer methods for a specific country
  Future<List<TransferMethod>> getAvailableTransferMethods(String countryCode) async {
    // In a real app, this would be an API call
    // Simulating API response for development
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Common transfer methods
    final commonMethods = [
      TransferMethod(
        id: 'bank',
        name: 'Bank Transfer',
        icon: Icons.account_balance_outlined,
        fee: 3.99,
        estimatedTime: '1-2 business days',
        description: 'Transfer directly to a bank account',
      ),
    ];
    
    // Country-specific transfer methods
    final Map<String, List<TransferMethod>> countryMethods = {
      'NG': [
        TransferMethod(
          id: 'mobile_money_ng',
          name: 'Mobile Money',
          icon: Icons.phone_android_outlined,
          fee: 2.50,
          estimatedTime: '15 minutes',
          isPopular: true,
          description: 'Send to any Nigerian mobile money account',
        ),
      ],
      'GH': [
        TransferMethod(
          id: 'mobile_money_gh',
          name: 'Mobile Money',
          icon: Icons.phone_android_outlined,
          fee: 2.00,
          estimatedTime: '15 minutes',
          isPopular: true,
          description: 'Send to MTN, Vodafone or AirtelTigo Money',
        ),
      ],
      'KE': [
        TransferMethod(
          id: 'mpesa',
          name: 'M-Pesa',
          icon: Icons.phone_android_outlined,
          fee: 1.50,
          estimatedTime: '10 minutes',
          isPopular: true,
          description: 'Send directly to M-Pesa',
        ),
      ],
      'IN': [
        TransferMethod(
          id: 'upi',
          name: 'UPI Transfer',
          icon: Icons.smartphone_outlined,
          fee: 1.00,
          estimatedTime: '5 minutes',
          isPopular: true,
          description: 'Instant transfer via UPI',
        ),
      ],
      'PH': [
        TransferMethod(
          id: 'gcash',
          name: 'GCash',
          icon: Icons.account_balance_wallet_outlined,
          fee: 2.00,
          estimatedTime: '15 minutes',
          isPopular: true,
        ),
      ],
    };
    
    // Cash pickup is available for many countries
    final cashPickupCountries = ['NG', 'GH', 'KE', 'PH', 'IN', 'MX'];
    if (cashPickupCountries.contains(countryCode)) {
      commonMethods.add(
        TransferMethod(
          id: 'cash_pickup',
          name: 'Cash Pickup',
          icon: Icons.local_atm_outlined,
          fee: 5.99,
          estimatedTime: 'Same day',
          description: 'Available at local partner locations',
        ),
      );
    }
    
    // Add country specific methods to common methods
    final methods = [...commonMethods];
    if (countryMethods.containsKey(countryCode)) {
      methods.addAll(countryMethods[countryCode]!);
    }
    
    return methods;
  }
  
  /// Get available delivery options for a specific country and transfer method
  Future<List<String>> getDeliveryOptions(String countryCode) async {
    // In a real app, this would be an API call
    // Simulating API response for development
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Map of country codes to available delivery options
    final Map<String, List<String>> countryDeliveryOptions = {
      'NG': ['Standard', 'Express (24 hours)', 'Instant (additional fee)'],
      'GH': ['Standard', 'Express (24 hours)'],
      'KE': ['Standard', 'Express (24 hours)', 'Instant (additional fee)'],
      'ZA': ['Standard', 'Express (24 hours)'],
      'IN': ['Standard IMPS', 'NEFT', 'RTGS'],
      'PH': ['Standard', 'Express', 'Instant (selected partners only)'],
    };
    
    return countryDeliveryOptions[countryCode] ?? ['Standard'];
  }
  
  /// Get country information for a specific country code
  Future<Map<String, dynamic>> getCountryInfo(String countryCode) async {
    // In a real app, this would be an API call
    // Simulating API response for development
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Map of country codes to information
    final Map<String, Map<String, dynamic>> countryInfo = {
      'NG': {
        'name': 'Nigeria',
        'flagUrl': 'assets/flags/ng.png',
        'dialCode': '+234',
        'region': 'Africa',
        'requirements': [
          'Valid ID required for cash pickup',
          'Transfers above $500 require KYC verification',
        ],
        'popularCities': ['Lagos', 'Abuja', 'Kano', 'Ibadan'],
      },
      'GH': {
        'name': 'Ghana',
        'flagUrl': 'assets/flags/gh.png',
        'dialCode': '+233',
        'region': 'Africa',
        'requirements': [
          'Valid ID required for cash pickup',
          'Transfers above $500 require KYC verification',
        ],
        'popularCities': ['Accra', 'Kumasi', 'Tamale', 'Takoradi'],
      },
      'KE': {
        'name': 'Kenya',
        'flagUrl': 'assets/flags/ke.png',
        'dialCode': '+254',
        'region': 'Africa',
        'requirements': [
          'Valid ID required for cash pickup',
          'Transfers above $500 require KYC verification',
        ],
        'popularCities': ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru'],
      },
      'IN': {
        'name': 'India',
        'flagUrl': 'assets/flags/in.png',
        'dialCode': '+91',
        'region': 'Asia',
        'requirements': [
          'PAN card required for transfers above $1000',
          'Aadhaar verification for certain services',
        ],
        'popularCities': ['Mumbai', 'Delhi', 'Bangalore', 'Chennai'],
      },
    };
    
    return countryInfo[countryCode] ?? {
      'name': 'Unknown',
      'flagUrl': 'assets/flags/unknown.png',
      'region': 'International',
      'requirements': ['Valid ID required for all transfers'],
    };
  }
  
  /// Get popular destination countries for remittances
  Future<List<Map<String, dynamic>>> getPopularDestinations() async {
    // In a real app, this would be an API call
    // Simulating API response for development
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      {
        'countryCode': 'NG',
        'name': 'Nigeria',
        'flagUrl': 'assets/flags/ng.png',
        'popularity': 95,
      },
      {
        'countryCode': 'IN',
        'name': 'India',
        'flagUrl': 'assets/flags/in.png',
        'popularity': 90,
      },
      {
        'countryCode': 'PH',
        'name': 'Philippines',
        'flagUrl': 'assets/flags/ph.png',
        'popularity': 85,
      },
      {
        'countryCode': 'GH',
        'name': 'Ghana',
        'flagUrl': 'assets/flags/gh.png',
        'popularity': 80,
      },
      {
        'countryCode': 'KE',
        'name': 'Kenya',
        'flagUrl': 'assets/flags/ke.png',
        'popularity': 75,
      },
      {
        'countryCode': 'MX',
        'name': 'Mexico',
        'flagUrl': 'assets/flags/mx.png',
        'popularity': 70,
      },
    ];
  }
}