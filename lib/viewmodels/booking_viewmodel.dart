// lib/viewmodels/booking_viewmodel.dart
import 'package:flutter/material.dart';

class BookingViewModel extends ChangeNotifier {
  // ── Shared booking lists (in-memory state) ─────────────────
  final List<Map<String, String>> _activeBookings = [];
  final List<Map<String, String>> _completedBookings = [];

  List<Map<String, String>> get activeBookings =>
      List.unmodifiable(_activeBookings);
  List<Map<String, String>> get completedBookings =>
      List.unmodifiable(_completedBookings);

  // ── Booking form state ─────────────────────────────────────
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  int _selectedDuration = 2;
  String _selectedPayment = 'Cash on Arrival';

  final List<int> durationOptions = [1, 2, 3, 4, 6, 8];

  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  int get selectedDuration => _selectedDuration;
  String get selectedPayment => _selectedPayment;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setDuration(int hours) {
    _selectedDuration = hours;
    notifyListeners();
  }

  void setPayment(String method) {
    _selectedPayment = method;
    notifyListeners();
  }

  // ── Price calculation ──────────────────────────────────────
  double calculateSubtotal(String price) {
    final hourlyRate =
        double.tryParse(
          price.replaceAll('Rs ', '').replaceAll('/hr', '').trim(),
        ) ??
        50.0;
    return hourlyRate * _selectedDuration;
  }

  double calculateTax(String price) => calculateSubtotal(price) * 0.1;

  double calculateTotal(String price) =>
      calculateSubtotal(price) + calculateTax(price);

  // ── Add booking to active list ─────────────────────────────
  // latitude/longitude ab yahan store karte hain taake baad mein
  // "Get Directions" ke liye My Bookings se bhi use ho sakein.
  void addActiveBooking({
    required String parkingName,
    required String date,
    required String time,
    required String amount,
    required double latitude,
    required double longitude,
  }) {
    final id = 'BK${DateTime.now().millisecondsSinceEpoch}';
    _activeBookings.add({
      'id': id,
      'location': parkingName,
      'address': '123 Main Street, City Center',
      'date': date,
      'time': time,
      'slot': 'A-12',
      'amount': amount,
      'paymentMethod': _selectedPayment,
      'status': 'Active',
      'lat': latitude.toString(),
      'lng': longitude.toString(),
    });
    notifyListeners();
  }

  // ── Cancel a booking (moves it out of the active list) ─────
  void cancelBooking(String id) {
    _activeBookings.removeWhere((b) => b['id'] == id);
    notifyListeners();
  }

  // ── Reset booking form ─────────────────────────────────────
  void resetForm() {
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 9, minute: 0);
    _selectedDuration = 2;
    _selectedPayment = 'Cash on Arrival';
    notifyListeners();
  }

  // ── Tab index for MyBookingsView ───────────────────────────
  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  List<Map<String, String>> get currentList =>
      _selectedTab == 0 ? _activeBookings : _completedBookings;
}
