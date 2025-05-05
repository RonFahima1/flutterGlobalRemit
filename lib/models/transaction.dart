enum TransactionType { SEND, RECEIVE, EXCHANGE, TRANSFER }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final String currency;
  final DateTime date;
  final TransactionType type;
  final String? note;
  final double? fee;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.currency,
    required this.date,
    required this.type,
    this.note,
    this.fee,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'],
      date: DateTime.parse(json['date']),
      type: TransactionType.values.firstWhere(
        (type) => type.toString() == 'TransactionType.${json['type'].toUpperCase()}',
        orElse: () => TransactionType.TRANSFER,
      ),
      note: json['note'],
      fee: json['fee']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last.toLowerCase(),
    };
  }
}
