import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if credentials match the default user
      const defaultEmail = 'admin@example.com';
      const defaultPassword = 'password123';

      await Future.delayed(const Duration(seconds: 1));
       
      if (email == defaultEmail && password == defaultPassword) {
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
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _user != null;
  }
}
