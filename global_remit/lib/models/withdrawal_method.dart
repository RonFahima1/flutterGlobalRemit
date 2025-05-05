import 'package:flutter/material.dart';

class WithdrawalMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String? processingTime;
  final String? feeStructure;
  final String? accountFieldLabel;
  final List<String>? requiredFields;
  final bool isActive;

  WithdrawalMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.processingTime,
    this.feeStructure,
    this.accountFieldLabel,
    this.requiredFields,
    this.isActive = true,
  });

  factory WithdrawalMethod.fromJson(Map<String, dynamic> json) {
    return WithdrawalMethod(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      // This is a simplification - in a real app you'd handle icon mapping differently
      icon: _getIconForMethod(json['iconName']),
      processingTime: json['processingTime'],
      feeStructure: json['feeStructure'],
      accountFieldLabel: json['accountFieldLabel'],
      requiredFields: json['requiredFields'] != null
          ? List<String>.from(json['requiredFields'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': _getIconNameFromData(icon),
      'processingTime': processingTime,
      'feeStructure': feeStructure,
      'accountFieldLabel': accountFieldLabel,
      'requiredFields': requiredFields,
      'isActive': isActive,
    };
  }

  static IconData _getIconForMethod(String? iconName) {
    switch (iconName) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'atm':
        return Icons.atm;
      case 'cash_pickup':
        return Icons.storefront;
      case 'mobile_money':
        return Icons.smartphone;
      case 'card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.payment;
      default:
        return Icons.monetization_on;
    }
  }

  static String _getIconNameFromData(IconData icon) {
    if (icon == Icons.account_balance) return 'bank_transfer';
    if (icon == Icons.atm) return 'atm';
    if (icon == Icons.storefront) return 'cash_pickup';
    if (icon == Icons.smartphone) return 'mobile_money';
    if (icon == Icons.credit_card) return 'card';
    if (icon == Icons.payment) return 'paypal';
    return 'default';
  }
}