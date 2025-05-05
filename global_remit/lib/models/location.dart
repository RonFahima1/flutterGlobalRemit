import 'package:flutter/material.dart';

enum LocationType {
  atm,
  branch,
}

class ServiceLocation {
  final String id;
  final String name;
  final String address;
  final LocationType type;
  final double latitude;
  final double longitude;
  final double distance; // in kilometers
  final String? phone;
  final String? openingHours;
  final List<String>? services;
  final bool hasAccessibility;
  final bool isOperational;

  ServiceLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phone,
    this.openingHours,
    this.services,
    this.hasAccessibility = false,
    this.isOperational = true,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      type: json['type'] == 'atm' ? LocationType.atm : LocationType.branch,
      latitude: json['latitude'],
      longitude: json['longitude'],
      distance: json['distance'],
      phone: json['phone'],
      openingHours: json['openingHours'],
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : null,
      hasAccessibility: json['hasAccessibility'] ?? false,
      isOperational: json['isOperational'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type == LocationType.atm ? 'atm' : 'branch',
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'phone': phone,
      'openingHours': openingHours,
      'services': services,
      'hasAccessibility': hasAccessibility,
      'isOperational': isOperational,
    };
  }
}