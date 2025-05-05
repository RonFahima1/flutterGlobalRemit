import 'package:flutter/material.dart';

class TransferMethod {
  final String id;
  final String name;
  final IconData icon;
  final double fee;
  final String estimatedTime;
  final List<String>? supportedCountries;
  final List<String>? supportedCurrencies;
  final String? description;
  final bool isPopular;
  
  const TransferMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.fee,
    required this.estimatedTime,
    this.supportedCountries,
    this.supportedCurrencies,
    this.description,
    this.isPopular = false,
  });
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is TransferMethod &&
    runtimeType == other.runtimeType &&
    id == other.id;
    
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'Transfer Method: $name (Fee: $fee)';
  
  // Factory to create TransferMethod from JSON
  factory TransferMethod.fromJson(Map<String, dynamic> json) {
    // Parse icon data
    IconData iconData;
    try {
      iconData = IconData(
        json['iconCodePoint'] as int,
        fontFamily: json['iconFontFamily'] as String?,
        fontPackage: json['iconFontPackage'] as String?,
      );
    } catch (_) {
      // Default icon if we can't parse the stored one
      iconData = Icons.swap_horiz;
    }
    
    return TransferMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: iconData,
      fee: json['fee'] as double,
      estimatedTime: json['estimatedTime'] as String,
      supportedCountries: (json['supportedCountries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supportedCurrencies: (json['supportedCurrencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'fee': fee,
      'estimatedTime': estimatedTime,
      'supportedCountries': supportedCountries,
      'supportedCurrencies': supportedCurrencies,
      'description': description,
      'isPopular': isPopular,
    };
  }
  
  // Create a copy with updated fields
  TransferMethod copyWith({
    String? id,
    String? name,
    IconData? icon,
    double? fee,
    String? estimatedTime,
    List<String>? supportedCountries,
    List<String>? supportedCurrencies,
    String? description,
    bool? isPopular,
  }) {
    return TransferMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      fee: fee ?? this.fee,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      supportedCountries: supportedCountries ?? this.supportedCountries,
      supportedCurrencies: supportedCurrencies ?? this.supportedCurrencies,
      description: description ?? this.description,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}