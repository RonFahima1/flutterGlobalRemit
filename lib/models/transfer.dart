enum TransferStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled
}

class Transfer {
  final String id;
  final String referenceNumber;
  final TransferStatus status;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final double fee;
  final String beneficiaryId;
  final String transferMethodId;
  final String? note;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? failedAt;
  final DateTime? cancelledAt;
  final String? failureReason;
  final DateTime estimatedDeliveryDate;
  
  const Transfer({
    required this.id,
    required this.referenceNumber,
    required this.status,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.fee,
    required this.beneficiaryId,
    required this.transferMethodId,
    this.note,
    required this.createdAt,
    this.completedAt,
    this.failedAt,
    this.cancelledAt,
    this.failureReason,
    required this.estimatedDeliveryDate,
  });
  
  /// Get the total amount (including fee)
  double get totalAmount => amount + fee;
  
  /// Check if the transfer is in a final state
  bool get isFinalState => 
      status == TransferStatus.completed || 
      status == TransferStatus.failed || 
      status == TransferStatus.cancelled;
  
  /// Get human-readable status text
  String get statusText {
    switch (status) {
      case TransferStatus.pending:
        return 'Pending';
      case TransferStatus.processing:
        return 'Processing';
      case TransferStatus.completed:
        return 'Completed';
      case TransferStatus.failed:
        return 'Failed';
      case TransferStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Transfer &&
    runtimeType == other.runtimeType &&
    id == other.id;
    
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'Transfer $referenceNumber: $statusText';
  
  // Factory to create Transfer from JSON
  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'] as String,
      referenceNumber: json['referenceNumber'] as String,
      status: _parseStatus(json['status'] as String),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      amount: json['amount'] as double,
      convertedAmount: json['convertedAmount'] as double,
      fee: json['fee'] as double,
      beneficiaryId: json['beneficiaryId'] as String,
      transferMethodId: json['transferMethodId'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
      failedAt: json['failedAt'] != null 
          ? DateTime.parse(json['failedAt'] as String) 
          : null,
      cancelledAt: json['cancelledAt'] != null 
          ? DateTime.parse(json['cancelledAt'] as String) 
          : null,
      failureReason: json['failureReason'] as String?,
      estimatedDeliveryDate: DateTime.parse(json['estimatedDeliveryDate'] as String),
    );
  }
  
  // Parse status from string
  static TransferStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TransferStatus.pending;
      case 'processing':
        return TransferStatus.processing;
      case 'completed':
        return TransferStatus.completed;
      case 'failed':
        return TransferStatus.failed;
      case 'cancelled':
        return TransferStatus.cancelled;
      default:
        return TransferStatus.pending;
    }
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceNumber': referenceNumber,
      'status': statusText.toLowerCase(),
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'fee': fee,
      'beneficiaryId': beneficiaryId,
      'transferMethodId': transferMethodId,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failedAt': failedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'failureReason': failureReason,
      'estimatedDeliveryDate': estimatedDeliveryDate.toIso8601String(),
    };
  }
  
  // Create a copy with updated fields
  Transfer copyWith({
    String? id,
    String? referenceNumber,
    TransferStatus? status,
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? convertedAmount,
    double? fee,
    String? beneficiaryId,
    String? transferMethodId,
    String? note,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? failedAt,
    DateTime? cancelledAt,
    String? failureReason,
    DateTime? estimatedDeliveryDate,
  }) {
    return Transfer(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      fee: fee ?? this.fee,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      transferMethodId: transferMethodId ?? this.transferMethodId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      failedAt: failedAt ?? this.failedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      failureReason: failureReason ?? this.failureReason,
      estimatedDeliveryDate: estimatedDeliveryDate ?? this.estimatedDeliveryDate,
    );
  }
}