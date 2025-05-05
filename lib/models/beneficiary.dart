class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String? bankName;
  final String relationship;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? country;
  final String? swiftCode;
  final bool isFavorite;
  final DateTime createdAt;
  
  const Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.bankName,
    required this.relationship,
    this.email,
    this.phoneNumber,
    this.address,
    this.country,
    this.swiftCode,
    this.isFavorite = false,
    required this.createdAt,
  });
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Beneficiary &&
    runtimeType == other.runtimeType &&
    id == other.id;
    
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'Beneficiary: $name ($accountNumber)';
  
  // Factory to create Beneficiary from JSON
  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] as String,
      name: json['name'] as String,
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String?,
      relationship: json['relationship'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      country: json['country'] as String?,
      swiftCode: json['swiftCode'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'relationship': relationship,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'country': country,
      'swiftCode': swiftCode,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Create a copy with updated fields
  Beneficiary copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? bankName,
    String? relationship,
    String? email,
    String? phoneNumber,
    String? address,
    String? country,
    String? swiftCode,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      relationship: relationship ?? this.relationship,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      country: country ?? this.country,
      swiftCode: swiftCode ?? this.swiftCode,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}