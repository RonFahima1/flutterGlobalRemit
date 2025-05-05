class Beneficiary {
  final String id;
  final String name;
  final String accountNumber;
  final String bankName;
  final String country;
  final String currency;
  final String email;
  final String phone;
  final bool isFavorite;
  final DateTime? lastTransferDate;
  final String category;

  Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bankName,
    required this.country,
    required this.currency,
    required this.email,
    required this.phone,
    required this.isFavorite,
    required this.lastTransferDate,
    required this.category,
  });

  // Create a copy of this Beneficiary with some properties modified
  Beneficiary copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? bankName,
    String? country,
    String? currency,
    String? email,
    String? phone,
    bool? isFavorite,
    DateTime? lastTransferDate,
    String? category,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isFavorite: isFavorite ?? this.isFavorite,
      lastTransferDate: lastTransferDate ?? this.lastTransferDate,
      category: category ?? this.category,
    );
  }

  // Convert from JSON
  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'],
      name: json['name'],
      accountNumber: json['accountNumber'],
      bankName: json['bankName'],
      country: json['country'],
      currency: json['currency'],
      email: json['email'],
      phone: json['phone'],
      isFavorite: json['isFavorite'] ?? false,
      lastTransferDate: json['lastTransferDate'] != null 
          ? DateTime.parse(json['lastTransferDate']) 
          : null,
      category: json['category'] ?? 'Other',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'country': country,
      'currency': currency,
      'email': email,
      'phone': phone,
      'isFavorite': isFavorite,
      'lastTransferDate': lastTransferDate?.toIso8601String(),
      'category': category,
    };
  }
}