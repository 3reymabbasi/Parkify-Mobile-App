import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────
  bool _isPasswordVisible = false;
  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  bool _isAdminMode = false;

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
  bool get isAdminMode => _isAdminMode;

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

  void setAdminMode(bool isAdmin) {
    _isAdminMode = isAdmin;
    notifyListeners();
  }

  void clearLoginErrors() {
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }

  /// Returns true if validation passes
  bool validateLogin(String email, String password) {
    _emailError = null;
    _passwordError = null;
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

  /// Returns 'admin' | 'user' | null (null = invalid)
  Future<String?> login(String email, String password) async {
    if (!validateLogin(email, password)) return null;

    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _loading = false;
    notifyListeners();

    if (_isAdminMode) {
      if (email == 'admin@smartparkify.com' && password == 'admin123') {
        return 'admin';
      }
      return null; // invalid admin credentials
    }
    return 'user';
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
    if (phone.trim().isEmpty || phone.trim().length != 11) {
      _phoneError = 'Valid phone number';
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
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _loading = false;
    notifyListeners();
    return true;
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
    notifyListeners();
  }
}
