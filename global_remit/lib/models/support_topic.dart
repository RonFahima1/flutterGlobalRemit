import 'package:flutter/material.dart';

class SupportTopic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;
  final bool isPinned;
  
  const SupportTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.tags = const [],
    this.isPinned = false,
  });
  
  factory SupportTopic.fromJson(Map<String, dynamic> json) {
    return SupportTopic(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // This is a simplification - in a real app, you'd need to map icon names to IconData
      icon: _getIconFromName(json['iconName']),
      tags: (json['tags'] as List?)?.map((tag) => tag.toString()).toList() ?? [],
      isPinned: json['isPinned'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': _getIconName(icon),
      'tags': tags,
      'isPinned': isPinned,
    };
  }
  
  static IconData _getIconFromName(String? iconName) {
    switch (iconName) {
      case 'account_circle':
        return Icons.account_circle;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'credit_card':
        return Icons.credit_card;
      case 'security':
        return Icons.security;
      case 'smartphone':
        return Icons.smartphone;
      case 'attach_money':
        return Icons.attach_money;
      case 'business':
        return Icons.business;
      default:
        return Icons.help;
    }
  }
  
  static String _getIconName(IconData icon) {
    if (icon == Icons.account_circle) return 'account_circle';
    if (icon == Icons.swap_horiz) return 'swap_horiz';
    if (icon == Icons.credit_card) return 'credit_card';
    if (icon == Icons.security) return 'security';
    if (icon == Icons.smartphone) return 'smartphone';
    if (icon == Icons.attach_money) return 'attach_money';
    if (icon == Icons.business) return 'business';
    return 'help';
  }
}