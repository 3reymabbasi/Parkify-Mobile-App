import 'package:flutter/material.dart';
import '../services/driver_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final DriverService _driverService = DriverService();

  String _driverName = 'Loading...';
  String _driverEmail = '';
  String _driverPhone = '';
  bool _loading = false;

  bool _isDarkMode = false;
  bool _notificationsOn = true;

  String get driverName => _driverName;
  String get driverEmail => _driverEmail;
  String get driverPhone => _driverPhone;
  bool get loading => _loading;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsOn => _notificationsOn;

  Color get bgColor =>
      _isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF4F6F8);
  Color get textColor => _isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
  Color get cardColor => _isDarkMode ? const Color(0xFF1E1E2E) : Colors.white;
  Color get subTextColor => _isDarkMode ? Colors.white54 : Colors.black45;
  Color get dividerColor => _isDarkMode ? Colors.white12 : Colors.black12;

  static const Color primary = Color(0xFF00796B);
  static const Color primaryDark = Color(0xFF004D40);
  static const Color accent = Color(0xFF00BFA5);

  // ── Load profile from Firestore ────────────────────────────
  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await _driverService.getDriverProfile();
      if (data != null) {
        _driverName = data['name']?.toString() ?? 'Driver';
        _driverEmail = data['email']?.toString() ?? '';
        _driverPhone = data['phone']?.toString() ?? '';
      }
    } catch (e) {
      // keep defaults
    }

    _loading = false;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsOn = value;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    _loading = true;
    notifyListeners();

    final success = await _driverService.updateProfile(
      name: name,
      phone: phone,
    );

    if (success) {
      _driverName = name;
      _driverPhone = phone;
    }

    _loading = false;
    notifyListeners();
    return success;
  }
}
