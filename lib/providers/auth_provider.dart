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

  Future<void> updateAcademicDetails(String userId, {
    String? regNumber,
    String? course,
    String? currentYear,
    String? section,
    String? cgpa,
  }) async {
    try {
      await _authService.updateUser(userId, {
        if (regNumber != null) 'regNumber': regNumber,
        if (course != null) 'course': course,
        if (currentYear != null) 'currentYear': currentYear,
        if (section != null) 'section': section,
        if (cgpa != null) 'cgpa': cgpa,
      });
      // Update local user object
      if (_user != null) {
        _user = AppUser(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          role: _user!.role,
          regNumber: regNumber ?? _user!.regNumber,
          course: course ?? _user!.course,
          currentYear: currentYear ?? _user!.currentYear,
          section: section ?? _user!.section,
          cgpa: cgpa ?? _user!.cgpa,
          phone: _user!.phone,
          address: _user!.address,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update academic details: ${e.toString()}';
      notifyListeners();
      throw e;
    }
  }

  Future<void> updatePersonalDetails(String userId, {
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      await _authService.updateUser(userId, {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      });
      // Update local user object
      if (_user != null) {
        _user = AppUser(
          id: _user!.id,
          name: name ?? _user!.name,
          email: _user!.email,
          role: _user!.role,
          regNumber: _user!.regNumber,
          course: _user!.course,
          currentYear: _user!.currentYear,
          section: _user!.section,
          cgpa: _user!.cgpa,
          phone: phone ?? _user!.phone,
          address: address ?? _user!.address,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update personal details: ${e.toString()}';
      notifyListeners();
      throw e;
    }
  }

  Future<void> loadCurrentUser() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }
} 