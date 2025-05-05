import 'package:flutter/material.dart';

enum NotificationType {
  transaction,
  security,
  promotion,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionText;
  final String? reference;
  final String? imageUrl;
  
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionText,
    this.reference,
    this.imageUrl,
  });
  
  String get category {
    switch (type) {
      case NotificationType.transaction:
        return 'Transactions';
      case NotificationType.security:
        return 'Security';
      case NotificationType.promotion:
        return 'Promotions';
      case NotificationType.system:
        return 'System';
    }
  }
  
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionText,
    String? reference,
    String? imageUrl,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionText: actionText ?? this.actionText,
      reference: reference ?? this.reference,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.system,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      actionText: json['actionText'],
      reference: json['reference'],
      imageUrl: json['imageUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      if (actionText != null) 'actionText': actionText,
      if (reference != null) 'reference': reference,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}