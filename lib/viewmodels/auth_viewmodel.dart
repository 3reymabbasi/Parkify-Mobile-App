import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // ── State ─────────────────────────────────────────────────
  bool _isPasswordVisible = false;
  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  bool _isManagerMode = false;
  String? _errorMessage;

  // Register state
  String? _nameError;
  String? _phoneError;
  String? _genderError;
  String? _gender;
  bool _isRegPasswordVisible = false;

  // ── Getters ────────────────────────────────────────────────
  bool get isPasswordVisible => _isPasswordVisible;
  bool get loading => _loading;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isManagerMode => _isManagerMode;
  String? get errorMessage => _errorMessage;

  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get genderError => _genderError;
  String? get gender => _gender;
  bool get isRegPasswordVisible => _isRegPasswordVisible;

  // ── Login Methods ──────────────────────────────────────────
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setManagerMode(bool isManager) {
    _isManagerMode = isManager;
    notifyListeners();
  }

  void clearLoginErrors() {
    _emailError = null;
    _passwordError = null;
    _errorMessage = null;
    notifyListeners();
  }

  bool validateLogin(String email, String password) {
    _emailError = null;
    _passwordError = null;
    _errorMessage = null;
    bool valid = true;

    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Valid email please';
      valid = false;
    }
    if (password.length < 6) {
      _passwordError = 'Password at least 6 characters';
      valid = false;
    }
    notifyListeners();
    return valid;
  }

  /// Returns 'manager' | 'driver' | null
  Future<String?> login(String email, String password) async {
    if (!validateLogin(email, password)) return null;

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email.trim(),
        password: password,
      );

      _loading = false;
      notifyListeners();

      // Success case
      if (result == 'manager' || result == 'driver') {
        if (_isManagerMode) {
          if (result == 'manager') {
            return 'manager';
          } else {
            _errorMessage = 'Invalid Manager Credentials';
            notifyListeners();
            return null;
          }
        }
        // Driver mode
        return 'driver';
      }

      // Error case (AuthService ne error message return kiya)
      _errorMessage = result ?? 'Login failed';
      notifyListeners();
      return null;
    } catch (e) {
      _loading = false;
      _errorMessage = 'Login failed: $e';
      notifyListeners();
      return null;
    }
  }

  // ── Register Methods ───────────────────────────────────────
  void toggleRegPasswordVisibility() {
    _isRegPasswordVisible = !_isRegPasswordVisible;
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value;
    notifyListeners();
  }

  bool validateRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    _nameError = null;
    _emailError = null;
    _phoneError = null;
    _genderError = null;
    _passwordError = null;
    _errorMessage = null;
    bool valid = true;

    if (name.trim().isEmpty) {
      _nameError = 'Name required';
      valid = false;
    }
    if (email.trim().isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      _emailError = 'Valid email please';
      valid = false;
    }
    if (phone.trim().isEmpty ||
        phone.trim().replaceAll(RegExp(r'\D'), '').length < 10) {
      _phoneError = 'Valid phone number (11 digits)';
      valid = false;
    }
    if (_gender == null) {
      _genderError = 'Please select gender';
      valid = false;
    }
    if (password.length < 6) {
      _passwordError = 'At least 6 characters';
      valid = false;
    }

    notifyListeners();
    return valid;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (!validateRegister(
      name: name,
      email: email,
      phone: phone,
      password: password,
    )) {
      return false;
    }

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.register(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
      gender: _gender ?? 'Other',
    );

    _loading = false;

    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  void resetState() {
    _isPasswordVisible = false;
    _loading = false;
    _emailError = null;
    _passwordError = null;
    _nameError = null;
    _phoneError = null;
    _genderError = null;
    _gender = null;
    _isRegPasswordVisible = false;
    _errorMessage = null;
    notifyListeners();
  }
}
