import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final String number;
  final String currency;
  final double balance;
  final Color color;

  Account({
    required this.id,
    required this.name,
    required this.number,
    required this.currency,
    required this.balance,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'currency': currency,
      'balance': balance,
      'color': color.value.toRadixString(16).padLeft(8, '0'),
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      currency: json['currency'],
      balance: json['balance'],
      color: Color(int.parse(json['color'].substring(2), radix: 16)),
    );
  }
}
