import '../models/location.dart';

class LocationService {
  // In a real app, this would use the device's location and make API calls
  Future<List<ServiceLocation>> getNearbyLocations() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Return mock data
    return [
      ServiceLocation(
        id: 'atm001',
        name: 'Global Remit ATM - Main Street',
        address: '123 Main St, Downtown, CA 90001',
        type: LocationType.atm,
        latitude: 34.0522,
        longitude: -118.2437,
        distance: 0.8,
        openingHours: '24/7',
        hasAccessibility: true,
        isOperational: true,
      ),
      ServiceLocation(
        id: 'branch001',
        name: 'Global Remit Branch - Financial District',
        address: '555 Finance Ave, Financial District, CA 90002',
        type: LocationType.branch,
        latitude: 34.0535,
        longitude: -118.2450,
        distance: 1.2,
        phone: '+1 (555) 123-4567',
        openingHours: 'Mon-Fri: 9:00 AM - 5:00 PM',
        services: ['Cash Deposits', 'Loans', 'Investment Advice', 'Money Transfer'],
        hasAccessibility: true,
        isOperational: true,
      ),
      ServiceLocation(
        id: 'atm002',
        name: 'Global Remit ATM - Shopping Center',
        address: '789 Market Ave, Shopping District, CA 90003',
        type: LocationType.atm,
        latitude: 34.0500,
        longitude: -118.2400,
        distance: 1.5,
        openingHours: 'Mall Hours: 10:00 AM - 9:00 PM',
        hasAccessibility: false,
        isOperational: true,
      ),
      ServiceLocation(
        id: 'branch002',
        name: 'Global Remit Branch - Westside',
        address: '321 West Blvd, Westside, CA 90004',
        type: LocationType.branch,
        latitude: 34.0480,
        longitude: -118.2500,
        distance: 2.3,
        phone: '+1 (555) 987-6543',
        openingHours: 'Mon-Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 2:00 PM',
        services: ['Cash Deposits', 'Loans', 'Money Transfer'],
        hasAccessibility: true,
        isOperational: true,
      ),
      ServiceLocation(
        id: 'atm003',
        name: 'Global Remit ATM - University',
        address: '456 Campus Rd, University Area, CA 90005',
        type: LocationType.atm,
        latitude: 34.0550,
        longitude: -118.2550,
        distance: 2.7,
        openingHours: '24/7',
        hasAccessibility: true,
        isOperational: false, // Out of service
      ),
      ServiceLocation(
        id: 'atm004',
        name: 'Global Remit ATM - Eastside Mall',
        address: '890 East Ave, Eastside, CA 90006',
        type: LocationType.atm,
        latitude: 34.0600,
        longitude: -118.2350,
        distance: 3.0,
        openingHours: 'Mall Hours: 10:00 AM - 9:00 PM',
        hasAccessibility: true,
        isOperational: true,
      ),
      ServiceLocation(
        id: 'branch003',
        name: 'Global Remit Branch - North Hills',
        address: '123 Hill St, North Hills, CA 90007',
        type: LocationType.branch,
        latitude: 34.0650,
        longitude: -118.2370,
        distance: 3.5,
        phone: '+1 (555) 456-7890',
        openingHours: 'Mon-Fri: 9:00 AM - 5:00 PM',
        services: ['Cash Deposits', 'Premium Services', 'Money Transfer', 'Foreign Exchange'],
        hasAccessibility: true,
        isOperational: true,
      ),
    ];
  }

  // In a real implementation, this would use device GPS
  Future<Map<String, dynamic>> getCurrentLocation() async {
    // Simulate getting location from device
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Default location (Los Angeles)
    return {
      'latitude': 34.0522,
      'longitude': -118.2437,
      'address': 'Los Angeles, CA',
    };
  }
  
  // In a real implementation, this would query directions from a maps API
  Future<Map<String, dynamic>> getDirections(
    double fromLat,
    double fromLng,
    double toLat,
    double toLng,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock response with route details
    return {
      'distance': '2.3 km',
      'duration': '8 mins',
      'steps': [
        'Head north on Main St',
        'Turn right onto 5th Ave',
        'Turn left onto Pine St',
        'Your destination will be on the right',
      ],
    };
  }
}