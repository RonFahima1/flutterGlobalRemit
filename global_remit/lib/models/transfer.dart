class Transfer {
  final String id;
  final double amount;
  final String currency;
  final String recipientName;
  final String recipientAccount;
  final String transferMethod; // 'Bank Transfer', 'Mobile Money', 'Cash Pickup', etc.
  final DateTime date;
  final String status; // 'Pending', 'Completed', 'Failed', 'Cancelled'
  final double? exchangeRate;
  final double? fee;
  final String? note;
  final String? referenceNumber;

  Transfer({
    String? id, // Optional so it can be generated
    required this.amount,
    this.currency = 'USD',
    required this.recipientName,
    required this.recipientAccount,
    required this.transferMethod,
    required this.date,
    this.status = 'Pending',
    this.exchangeRate,
    this.fee,
    this.note,
    this.referenceNumber,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Total amount including fees
  double get totalAmount => amount + (fee ?? 0.0);

  // Create a copy of this Transfer with some properties modified
  Transfer copyWith({
    String? id,
    double? amount,
    String? currency,
    String? recipientName,
    String? recipientAccount,
    String? transferMethod,
    DateTime? date,
    String? status,
    double? exchangeRate,
    double? fee,
    String? note,
    String? referenceNumber,
  }) {
    return Transfer(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      transferMethod: transferMethod ?? this.transferMethod,
      date: date ?? this.date,
      status: status ?? this.status,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      fee: fee ?? this.fee,
      note: note ?? this.note,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }

  // Convert from JSON
  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      recipientName: json['recipientName'],
      recipientAccount: json['recipientAccount'],
      transferMethod: json['transferMethod'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      exchangeRate: json['exchangeRate']?.toDouble(),
      fee: json['fee']?.toDouble(),
      note: json['note'],
      referenceNumber: json['referenceNumber'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'recipientName': recipientName,
      'recipientAccount': recipientAccount,
      'transferMethod': transferMethod,
      'date': date.toIso8601String(),
      'status': status,
      'exchangeRate': exchangeRate,
      'fee': fee,
      'note': note,
      'referenceNumber': referenceNumber,
    };
  }
}