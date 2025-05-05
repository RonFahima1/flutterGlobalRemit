import 'package:flutter/foundation.dart';

/// Beneficiary model class
class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String? bankName;
  final String? bankCode;
  final String? accountType;
  final String? city;
  final String country;
  final String countryCode;
  final String? phoneNumber;
  final String? email;
  final String? relationship;
  final bool isFavorite;
  final DateTime createdAt;
  
  /// Default constructor
  const Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.bankName,
    this.bankCode,
    this.accountType,
    this.city,
    required this.country,
    required this.countryCode,
    this.phoneNumber,
    this.email,
    this.relationship,
    this.isFavorite = false,
    required this.createdAt,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Beneficiary &&
      other.id == id &&
      other.name == name &&
      other.accountNumber == accountNumber;
  }
  
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ accountNumber.hashCode;
  
  @override
  String toString() => 'Beneficiary: $name ($accountNumber)';
  
  /// Create from JSON
  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] as String,
      name: json['name'] as String,
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String?,
      bankCode: json['bankCode'] as String?,
      accountType: json['accountType'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      relationship: json['relationship'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'bankCode': bankCode,
      'accountType': accountType,
      'city': city,
      'country': country,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'relationship': relationship,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Create a copy with changes
  Beneficiary copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? bankName,
    String? bankCode,
    String? accountType,
    String? city,
    String? country,
    String? countryCode,
    String? phoneNumber,
    String? email,
    String? relationship,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      accountType: accountType ?? this.accountType,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
