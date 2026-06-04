import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  // ── User Data ──────────────────────────────────────────────
  String _userName = 'John Doe';
  final String userEmail = 'john.doe@smartparkify.com';
  String _userPhone = '+92 300 1234567';

  String get userName => _userName;
  String get userPhone => _userPhone;

  // ── Settings ───────────────────────────────────────────────
  bool _isDarkMode = false;
  bool _notificationsOn = true;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsOn => _notificationsOn;

  // ── Theme colors (derived) ─────────────────────────────────
  Color get bgColor =>
      _isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF4F6F8);
  Color get textColor => _isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
  Color get cardColor => _isDarkMode ? const Color(0xFF1E1E2E) : Colors.white;
  Color get subTextColor => _isDarkMode ? Colors.white54 : Colors.black45;
  Color get dividerColor => _isDarkMode ? Colors.white12 : Colors.black12;

  static const Color primary = Color(0xFF00796B);
  static const Color primaryDark = Color(0xFF004D40);
  static const Color accent = Color(0xFF00BFA5);

  // ── Actions ────────────────────────────────────────────────
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsOn = value;
    notifyListeners();
  }

  void updateProfile({required String name, required String phone}) {
    _userName = name;
    _userPhone = phone;
    notifyListeners();
  }
}
