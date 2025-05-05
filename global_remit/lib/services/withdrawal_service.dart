import 'package:flutter/material.dart';
import '../models/withdrawal_method.dart';

class WithdrawalService {
  // In a real app, these would be fetched from an API
  Future<List<WithdrawalMethod>> getWithdrawalMethods() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data
    return [
      WithdrawalMethod(
        id: 'bank_transfer',
        name: 'Bank Transfer',
        description: 'Transfer funds directly to your bank account',
        icon: Icons.account_balance,
        processingTime: '1-3 business days',
        feeStructure: '1% (min $3)',
        accountFieldLabel: 'Bank Account Number',
        requiredFields: ['accountNumber', 'routingNumber', 'accountName'],
      ),
      WithdrawalMethod(
        id: 'atm',
        name: 'ATM Withdrawal',
        description: 'Withdraw cash from any supported ATM',
        icon: Icons.atm,
        processingTime: 'Immediate',
        feeStructure: '$2.50 per transaction',
        accountFieldLabel: 'Card Number',
      ),
      WithdrawalMethod(
        id: 'cash_pickup',
        name: 'Cash Pickup',
        description: 'Collect cash at any partner location',
        icon: Icons.storefront,
        processingTime: 'Same day',
        feeStructure: '2% (min $5)',
        accountFieldLabel: 'Recipient ID',
      ),
      WithdrawalMethod(
        id: 'mobile_money',
        name: 'Mobile Money',
        description: 'Transfer to your mobile money account',
        icon: Icons.smartphone,
        processingTime: 'Within 1 hour',
        feeStructure: '1.5% (min $2)',
        accountFieldLabel: 'Mobile Number',
      ),
    ];
  }

  Future<Map<String, dynamic>> processWithdrawal({
    required WithdrawalMethod method,
    required double amount,
    required String targetAccount,
    String? description,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Validate withdrawal
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
    
    if (amount > 10000) {
      throw Exception('Amount exceeds maximum withdrawal limit');
    }
    
    // In a real app, we would call an actual API and handle errors properly
    
    // Return mock success response
    return {
      'success': true,
      'transactionId': 'WD${DateTime.now().millisecondsSinceEpoch}',
      'method': method.id,
      'amount': amount,
      'targetAccount': targetAccount,
      'description': description,
      'status': 'pending',
      'timestamp': DateTime.now().toIso8601String(),
      'estimatedCompletionTime': _calculateEstimatedCompletionTime(method.processingTime),
    };
  }

  String _calculateEstimatedCompletionTime(String? processingTime) {
    final now = DateTime.now();
    
    if (processingTime == null) {
      // Default to 3 business days if unknown
      return _addBusinessDays(now, 3).toIso8601String();
    }
    
    if (processingTime.contains('Immediate') || processingTime.contains('Within 1 hour')) {
      return now.add(const Duration(hours: 1)).toIso8601String();
    }
    
    if (processingTime.contains('Same day')) {
      return DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
    }
    
    if (processingTime.contains('1-3 business days')) {
      return _addBusinessDays(now, 3).toIso8601String();
    }
    
    // Default fallback
    return _addBusinessDays(now, 5).toIso8601String();
  }
  
  DateTime _addBusinessDays(DateTime date, int days) {
    int count = 0;
    DateTime current = date;
    
    while (count < days) {
      current = current.add(const Duration(days: 1));
      
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (current.weekday != 6 && current.weekday != 7) {
        count++;
      }
    }
    
    return current;
  }
}