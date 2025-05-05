import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beneficiary.dart';
import '../models/transfer.dart';

class TransferService {
  final String baseUrl = 'https://api.globalremit.app/v1';
  
  /// Get exchange rate between two currencies
  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock exchange rates
      final Map<String, Map<String, double>> mockRates = {
        'USD': {
          'EUR': 0.92,
          'GBP': 0.79,
          'JPY': 149.75,
          'CAD': 1.38,
          'AUD': 1.53,
          'INR': 83.12,
          'NGN': 1550.00,
          'GHS': 14.28,
          'KES': 132.50,
        },
        'EUR': {
          'USD': 1.09,
          'GBP': 0.86,
          'JPY': 163.40,
          'CAD': 1.50,
          'AUD': 1.66,
          'INR': 90.46,
          'NGN': 1687.80,
          'GHS': 15.55,
          'KES': 144.28,
        },
        'GBP': {
          'USD': 1.27,
          'EUR': 1.17,
          'JPY': 190.55,
          'CAD': 1.75,
          'AUD': 1.94,
          'INR': 105.58,
          'NGN': 1969.44,
          'GHS': 18.14,
          'KES': 168.37,
        },
      };
      
      // Default rates for other currencies not explicitly defined
      if (!mockRates.containsKey(fromCurrency)) {
        return 1.0;  // Default to 1:1 for unsupported currencies
      }
      
      final rates = mockRates[fromCurrency]!;
      return rates[toCurrency] ?? 1.0;
    } catch (e) {
      throw Exception('Failed to get exchange rate: $e');
    }
  }
  
  /// Get list of beneficiaries
  Future<List<Beneficiary>> getBeneficiaries() async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate mock beneficiaries
      return [
        Beneficiary(
          id: 'ben_001',
          name: 'John Smith',
          accountNumber: '1234567890',
          bankName: 'Global Bank',
          relationship: 'Family',
          email: 'john.smith@example.com',
          phoneNumber: '+1 234 567 8901',
          country: 'United States',
          isFavorite: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Beneficiary(
          id: 'ben_002',
          name: 'Maria Rodriguez',
          accountNumber: '2345678901',
          bankName: 'Euro Bank',
          relationship: 'Friend',
          email: 'maria.r@example.com',
          country: 'Spain',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Beneficiary(
          id: 'ben_003',
          name: 'Kwame Asante',
          accountNumber: '3456789012',
          bankName: 'Ghana Commercial Bank',
          relationship: 'Business',
          phoneNumber: '+233 12 345 6789',
          country: 'Ghana',
          isFavorite: true,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Beneficiary(
          id: 'ben_004',
          name: 'Aisha Mohammed',
          accountNumber: '4567890123',
          bankName: 'First Bank',
          relationship: 'Family',
          phoneNumber: '+234 80 1234 5678',
          country: 'Nigeria',
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to get beneficiaries: $e');
    }
  }
  
  /// Initiate a money transfer
  Future<Transfer> initiateTransfer({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required double convertedAmount,
    required String beneficiaryId,
    required String transferMethodId,
    required double fee,
    String? note,
  }) async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate a random reference number
      final String refNumber = 'TR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      
      // Create a new transfer object
      final transfer = Transfer(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        referenceNumber: refNumber,
        status: TransferStatus.pending,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        amount: amount,
        convertedAmount: convertedAmount,
        fee: fee,
        beneficiaryId: beneficiaryId,
        transferMethodId: transferMethodId,
        note: note,
        createdAt: DateTime.now(),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
      );
      
      return transfer;
    } catch (e) {
      throw Exception('Failed to initiate transfer: $e');
    }
  }
  
  /// Confirm a money transfer
  Future<Transfer> confirmTransfer(String transferId) async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, we would get the transfer by ID from the API
      // For now, we'll just create a new transfer with confirmed status
      return Transfer(
        id: transferId,
        referenceNumber: 'TR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        status: TransferStatus.completed,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        amount: 100.0,
        convertedAmount: 92.0,
        fee: 2.5,
        beneficiaryId: 'ben_001',
        transferMethodId: 'bank',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
      );
    } catch (e) {
      throw Exception('Failed to confirm transfer: $e');
    }
  }
  
  /// Get transfer status
  Future<TransferStatus> getTransferStatus(String transferId) async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(milliseconds: 800));
      
      // For demo, randomly return different statuses
      final statuses = [
        TransferStatus.pending,
        TransferStatus.processing,
        TransferStatus.completed,
      ];
      
      final randomIndex = transferId.hashCode % statuses.length;
      return statuses[randomIndex.abs()];
    } catch (e) {
      throw Exception('Failed to get transfer status: $e');
    }
  }
  
  /// Get transfer history
  Future<List<Transfer>> getTransferHistory() async {
    try {
      // This would be an API call in a real application
      // Simulating API response for development
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate mock transfer history
      return [
        Transfer(
          id: 'txn_001',
          referenceNumber: 'TR123456',
          status: TransferStatus.completed,
          fromCurrency: 'USD',
          toCurrency: 'EUR',
          amount: 500.0,
          convertedAmount: 460.0,
          fee: 4.99,
          beneficiaryId: 'ben_002',
          transferMethodId: 'bank',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          completedAt: DateTime.now().subtract(const Duration(days: 4)),
          estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Transfer(
          id: 'txn_002',
          referenceNumber: 'TR789012',
          status: TransferStatus.processing,
          fromCurrency: 'USD',
          toCurrency: 'GHS',
          amount: 200.0,
          convertedAmount: 2856.0,
          fee: 2.5,
          beneficiaryId: 'ben_003',
          transferMethodId: 'mobile',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transfer(
          id: 'txn_003',
          referenceNumber: 'TR345678',
          status: TransferStatus.failed,
          fromCurrency: 'USD',
          toCurrency: 'NGN',
          amount: 100.0,
          convertedAmount: 155000.0,
          fee: 2.5,
          beneficiaryId: 'ben_004',
          transferMethodId: 'bank',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          failedAt: DateTime.now().subtract(const Duration(days: 10)),
          failureReason: 'Insufficient funds',
          estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 9)),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to get transfer history: $e');
    }
  }
}