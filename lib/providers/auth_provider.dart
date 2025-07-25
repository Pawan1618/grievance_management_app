import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _user;
  bool _loading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isLoading => _loading;
  bool get isAdmin => _user?.role == 'admin';

  String? get errorMessage => _errorMessage;
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.login(email, password);
      if (_user == null) {
        _errorMessage = 'Invalid email or password.';
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password, String role) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.register(name, email, password, role);
      if (_user == null) {
        _errorMessage = 'Registration failed. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }
} 