import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? countryCode;
  final List<String>? recentRecipients;
  final Map<String, dynamic>? preferences;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phoneNumber,
    this.countryCode,
    this.recentRecipients,
    this.preferences,
    this.isVerified = false,
  });

  // First name getter
  String get firstName {
    final nameParts = name.split(' ');
    return nameParts.first;
  }

  // Last name getter
  String get lastName {
    final nameParts = name.split(' ');
    return nameParts.length > 1 ? nameParts.last : '';
  }

  // Factory constructor from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      countryCode: json['countryCode'] as String?,
      recentRecipients: json['recentRecipients'] != null 
          ? List<String>.from(json['recentRecipients'])
          : null,
      preferences: json['preferences'] as Map<String, dynamic>?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'recentRecipients': recentRecipients,
      'preferences': preferences,
      'isVerified': isVerified,
    };
  }

  // Copy with
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
    String? countryCode,
    List<String>? recentRecipients,
    Map<String, dynamic>? preferences,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      recentRecipients: recentRecipients ?? this.recentRecipients,
      preferences: preferences ?? this.preferences,
      isVerified: isVerified ?? this.isVerified,
    );
  }
  
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
