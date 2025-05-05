import 'package:flutter/foundation.dart';

/// Currency model class
class Currency {
  final String code;
  final String symbol;
  final String name;
  
  /// Default constructor
  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });
  
  /// Create from JSON
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
    };
  }
  
  /// Create a copy with changes
  Currency copyWith({
    String? code,
    String? symbol,
    String? name,
  }) {
    return Currency(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Currency &&
      other.code == code &&
      other.symbol == symbol &&
      other.name == name;
  }
  
  @override
  int get hashCode => code.hashCode ^ symbol.hashCode ^ name.hashCode;
  
  @override
  String toString() => '$name ($code)';
}
