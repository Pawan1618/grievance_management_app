import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _user;
  bool _loading = false;

  AppUser? get user => _user;
  bool get isLoading => _loading;
  bool get isAdmin => _user?.role == 'admin';

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await _authService.login(email, password);
    } catch (e) {
      // Optionally store error for UI
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password, String role) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await _authService.register(name, email, password, role);
    } catch (e) {
      // Optionally store error for UI
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