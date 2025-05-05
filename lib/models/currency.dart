class Currency {
  final String code;
  final String symbol;
  final String name;
  
  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Currency &&
    runtimeType == other.runtimeType &&
    code == other.code;
    
  @override
  int get hashCode => code.hashCode;
  
  @override
  String toString() => '$name ($code)';
  
  // Factory to create Currency from JSON
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
    };
  }
  
  // Create a copy with updated fields
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
}