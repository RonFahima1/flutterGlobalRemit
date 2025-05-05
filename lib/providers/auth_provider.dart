import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login({required String email, required String password}) async {
    debugPrint('AuthProvider: Attempting login with email: $email');
    if (_isLoading) return false;
    
    _isLoading = true;
    notifyListeners();

    try {
      // For debugging purposes, let's add a timeout
      final loginFuture = _performLoginLogic(email, password);
      final timeoutFuture = Future.delayed(const Duration(seconds: 5), () {
        throw TimeoutException('Login request timed out');
      });
      
      // Use the first future that completes
      return await Future.any([loginFuture, timeoutFuture]);
    } catch (e) {
      debugPrint('AuthProvider: Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _performLoginLogic(String email, String password) async {
    debugPrint('AuthProvider: Performing login logic');
    try {
      // Check if credentials match the default user
      const defaultEmail = 'admin@example.com';
      const defaultPassword = 'password123';

      await Future.delayed(const Duration(seconds: 1));
       
      if (email == defaultEmail && password == defaultPassword) {
        debugPrint('AuthProvider: Login successful');
        _user = User(
          id: '1',
          name: 'John Doe',
          email: email,
          avatarUrl: 'https://via.placeholder.com/150',
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
       
      // Invalid credentials
      debugPrint('AuthProvider: Invalid credentials');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('AuthProvider: Error in login logic: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    debugPrint('AuthProvider: Signing out');
    _user = null;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    debugPrint('AuthProvider: Checking if user is logged in');
    try {
      // Add a small delay to simulate checking
      await Future.delayed(const Duration(milliseconds: 300));
      return _user != null;
    } catch (e) {
      debugPrint('AuthProvider: Error checking login status: $e');
      return false;
    }
  }
}
