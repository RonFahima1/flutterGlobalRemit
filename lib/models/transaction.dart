import 'package:flutter/foundation.dart';

/// Transaction status enum
enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled;
  
  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Transaction type enum
enum TransactionType {
  send,
  receive,
  exchange,
  transfer;
  
  String get displayName {
    switch (this) {
      case TransactionType.send:
        return 'Send';
      case TransactionType.receive:
        return 'Receive';
      case TransactionType.exchange:
        return 'Exchange';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }
}

/// Transaction model class
class Transaction {
  final String id;
  final String? recipientName;
  final String? recipientCountry;
  final double amount;
  final String sourceCurrency;
  final double? fee;
  final DateTime date;
  final TransactionStatus status;
  final TransactionType type;
  final String? referenceNumber;
  final String? description;
  final String? note;
  final double? exchangeRate;
  final String? recipientBank;
  final String? destinationCurrency;

  /// Default constructor
  const Transaction({
    required this.id,
    this.recipientName,
    this.recipientCountry,
    required this.amount,
    required this.sourceCurrency,
    this.fee,
    required this.date,
    required this.status,
    required this.type,
    this.referenceNumber,
    this.description,
    this.note,
    this.exchangeRate,
    this.recipientBank,
    this.destinationCurrency,
  });

  /// Total amount including fee
  double get totalAmount => amount + (fee ?? 0);
  
  /// Formatted status
  String get statusText => status.displayName;

  /// Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      recipientName: json['recipientName'],
      recipientCountry: json['recipientCountry'],
      amount: json['amount'] is String 
          ? double.parse(json['amount']) 
          : (json['amount'] as num).toDouble(),
      sourceCurrency: json['sourceCurrency'] ?? json['currency'],
      fee: json['fee'] != null ? (json['fee'] as num).toDouble() : null,
      date: DateTime.parse(json['date']),
      status: _parseStatus(json['status']),
      type: _parseType(json['type']),
      referenceNumber: json['referenceNumber'],
      description: json['description'],
      note: json['note'],
      exchangeRate: json['exchangeRate'] != null
          ? (json['exchangeRate'] as num).toDouble()
          : null,
      recipientBank: json['recipientBank'],
      destinationCurrency: json['destinationCurrency'],
    );
  }
  
  /// Parse transaction status from string
  static TransactionStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return TransactionStatus.completed;
    
    try {
      return TransactionStatus.values.firstWhere(
        (e) => e.name == statusStr.toLowerCase(),
        orElse: () => TransactionStatus.pending,
      );
    } catch (_) {
      return TransactionStatus.pending;
    }
  }
  
  /// Parse transaction type from string
  static TransactionType _parseType(String? typeStr) {
    if (typeStr == null) return TransactionType.transfer;
    
    try {
      return TransactionType.values.firstWhere(
        (e) => e.name == typeStr.toLowerCase(),
        orElse: () => TransactionType.transfer,
      );
    } catch (_) {
      return TransactionType.transfer;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'recipientCountry': recipientCountry,
      'amount': amount,
      'sourceCurrency': sourceCurrency,
      'fee': fee,
      'date': date.toIso8601String(),
      'status': status.name,
      'type': type.name,
      'referenceNumber': referenceNumber,
      'description': description,
      'note': note,
      'exchangeRate': exchangeRate,
      'recipientBank': recipientBank,
      'destinationCurrency': destinationCurrency,
    };
  }

  /// Create a copy with changes
  Transaction copyWith({
    String? id,
    String? recipientName,
    String? recipientCountry,
    double? amount,
    String? sourceCurrency,
    double? fee,
    DateTime? date,
    TransactionStatus? status,
    TransactionType? type,
    String? referenceNumber,
    String? description,
    String? note,
    double? exchangeRate,
    String? recipientBank,
    String? destinationCurrency,
  }) {
    return Transaction(
      id: id ?? this.id,
      recipientName: recipientName ?? this.recipientName,
      recipientCountry: recipientCountry ?? this.recipientCountry,
      amount: amount ?? this.amount,
      sourceCurrency: sourceCurrency ?? this.sourceCurrency,
      fee: fee ?? this.fee,
      date: date ?? this.date,
      status: status ?? this.status,
      type: type ?? this.type,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      description: description ?? this.description,
      note: note ?? this.note,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      recipientBank: recipientBank ?? this.recipientBank,
      destinationCurrency: destinationCurrency ?? this.destinationCurrency,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Transaction &&
      other.id == id &&
      other.date == date;
  }
  
  @override
  int get hashCode => id.hashCode ^ date.hashCode;
  
  @override
  String toString() => 'Transaction $id: $sourceCurrency $amount';
}
