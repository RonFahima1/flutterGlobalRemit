import 'package:flutter/material.dart';

/// AppProgressTracker provides utilities to track and display the progress
/// of screen implementations throughout the Global Remit app.
class AppProgressTracker {
  // Total number of screens in the implementation plan
  static const int totalScreens = 41;
  
  // Current number of completed screens
  static const int completedScreens = 10;
  
  // Screens currently in progress
  static const List<int> inProgressScreens = [18, 19];
  
  // Implementation phases with their respective screens
  static const Map<String, List<int>> phases = {
    'Core & Authentication': [1, 2, 3, 4, 5, 6, 7],
    'Account & Transactions': [8, 9, 10, 11, 12],
    'Cards Management': [13, 14, 15, 16, 17],
    'Transfers & Payments': [18, 19, 20, 21, 22, 23, 24],
    'Deposits & Withdrawals': [25, 26, 27, 28, 29],
    'Profile & KYC': [30, 31, 32, 33, 34, 35],
    'Support & Settings': [36, 37, 38, 39, 40, 41],
  };
  
  // Screen names mapped to their numbers
  static const Map<int, String> screenNames = {
    1: 'Splash Screen',
    2: 'Login Screen',
    3: 'Registration Screen',
    4: 'Forgot Password Screen',
    5: 'Onboarding Screens',
    6: 'Two-Factor Authentication Screen',
    7: 'Dashboard/Home Screen',
    8: 'Account Overview Screen',
    9: 'Transaction History Screen',
    10: 'Transaction Detail Screen',
    11: 'Account Statement Screen',
    12: 'Analytics & Spending Insights Screen',
    13: 'Card Preview Widget',
    14: 'Card Detail Screen',
    15: 'Virtual Card Creation Screen',
    16: 'Card Settings Screen',
    17: 'Card Transaction History Screen',
    18: 'Transfer Money Screen',
    19: 'Transfer Confirmation Screen',
    20: 'International Remittance Screen',
    21: 'QR Payment Screen',
    22: 'Scheduled Transfers Screen',
    23: 'Beneficiaries Management Screen',
    24: 'Add Beneficiary Screen',
    25: 'Deposit Methods Screen',
    26: 'Deposit Processing Screen',
    27: 'Withdrawal Methods Screen',
    28: 'Withdrawal Processing Screen',
    29: 'ATM & Branch Locator Screen',
    30: 'Profile Screen',
    31: 'Profile Edit Screen',
    32: 'KYC Documents Upload Screen',
    33: 'Identity Verification Screen',
    34: 'Address Verification Screen',
    35: 'Security Settings Screen',
    36: 'Customer Support Screen',
    37: 'Live Chat Screen',
    38: 'FAQ & Help Center Screen',
    39: 'App Settings Screen',
    40: 'Notification Center Screen',
    41: 'About & Legal Information Screen',
  };
  
  /// Get the screen status icon
  static Widget getScreenStatusIcon(int screenNumber) {
    if (screenNumber <= completedScreens) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 18);
    } else if (inProgressScreens.contains(screenNumber)) {
      return const Icon(Icons.pending, color: Color(0xFFFFB800), size: 18);
    } else {
      return const Icon(Icons.circle_outlined, color: Colors.grey, size: 18);
    }
  }
  
  /// Get the screen status text
  static String getScreenStatusText(int screenNumber) {
    if (screenNumber <= completedScreens) {
      return 'COMPLETED';
    } else if (inProgressScreens.contains(screenNumber)) {
      return 'IN PROGRESS';
    } else {
      return 'PENDING';
    }
  }
  
  /// Get the screen status color
  static Color getScreenStatusColor(int screenNumber) {
    if (screenNumber <= completedScreens) {
      return Colors.green;
    } else if (inProgressScreens.contains(screenNumber)) {
      return const Color(0xFFFFB800);
    } else {
      return Colors.grey;
    }
  }
  
  /// Get the phase progress (completed/total)
  static String getPhaseProgress(String phaseName) {
    if (!phases.containsKey(phaseName)) return '0/0';
    
    final phaseScreens = phases[phaseName]!;
    final completed = phaseScreens.where((screen) => screen <= completedScreens).length;
    
    return '$completed/${phaseScreens.length}';
  }
  
  /// Get the phase completion percentage
  static double getPhaseCompletionPercentage(String phaseName) {
    if (!phases.containsKey(phaseName)) return 0.0;
    
    final phaseScreens = phases[phaseName]!;
    if (phaseScreens.isEmpty) return 0.0;
    
    final completed = phaseScreens.where((screen) => screen <= completedScreens).length;
    
    return completed / phaseScreens.length;
  }
  
  /// Get the overall implementation completion percentage
  static double getOverallCompletionPercentage() {
    return completedScreens / totalScreens;
  }
  
  /// Check if a screen is completed
  static bool isScreenCompleted(int screenNumber) {
    return screenNumber <= completedScreens;
  }
  
  /// Check if a screen is in progress
  static bool isScreenInProgress(int screenNumber) {
    return inProgressScreens.contains(screenNumber);
  }
  
  /// Get the phase name for a screen
  static String? getPhaseForScreen(int screenNumber) {
    for (final entry in phases.entries) {
      if (entry.value.contains(screenNumber)) {
        return entry.key;
      }
    }
    return null;
  }
}