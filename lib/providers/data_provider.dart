import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class DataProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Account> _accounts = [];
  List<Transaction> _transactions = [];

  bool get isLoading => _isLoading;
  List<Account> get accounts => _accounts;
  List<Transaction> get transactions => _transactions;

  // Return a Future that can be awaited
  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 2));

      _accounts = [
        Account(
          id: '1',
          name: 'Checking Account',
          number: '1234567890123456',
          balance: 1500.00,
          currency: 'USD',
          color: const Color(0xFF4CAF50),
        ),
        Account(
          id: '2',
          name: 'Savings Account',
          number: '9876543210987654',
          balance: 5000.00,
          currency: 'USD',
          color: const Color(0xFF2196F3),
        ),
      ];

      _transactions = [
        Transaction(
          id: '1',
          description: 'Groceries',
          amount: 150.00,
          sourceCurrency: 'USD',
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.send,
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: '2',
          description: 'Salary',
          amount: 3000.00,
          sourceCurrency: 'USD',
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.receive,
          status: TransactionStatus.completed,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // Rethrow to allow error handling by caller
    }
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void updateBalance(String accountId, double amount) {
    final account = _accounts.firstWhere((acc) => acc.id == accountId);
    final index = _accounts.indexOf(account);
    final updatedAccount = Account(
      id: account.id,
      name: account.name,
      number: account.number,
      balance: account.balance + amount,
      currency: account.currency,
      color: account.color,
    );

    _accounts[index] = updatedAccount;
    notifyListeners();
  }
}
