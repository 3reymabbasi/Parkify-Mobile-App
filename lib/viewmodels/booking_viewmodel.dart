import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../models/booking_model.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _activeBookings = [];
  List<Booking> _completedBookings = [];
  bool _loading = false;

  List<Booking> get activeBookings => List.unmodifiable(_activeBookings);
  List<Booking> get completedBookings => List.unmodifiable(_completedBookings);
  bool get loading => _loading;

  // Form state
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

  // ── Real Firebase Booking ─────────────────────────────────
  Future<String?> addActiveBooking({
    required String parkingName,
    required String address,
    required String date,
    required String time,
    required String amount,
    required double latitude,
    required double longitude,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final bookingId = await _bookingService.addBooking(
        parkingName: parkingName,
        address: address.isNotEmpty ? address : 'Parking Location',
        date: date,
        time: time,
        slot: 'A-${DateTime.now().millisecond % 40 + 1}',
        amount: amount,
        paymentMethod: _selectedPayment,
      );

      _loading = false;
      notifyListeners();

      if (bookingId != null) {
        // Refresh list
        listenActiveBookings();
        return bookingId;
      }
      return null;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelBooking(String id) async {
    final success = await _bookingService.cancelBooking(id);
    if (success) {
      _activeBookings.removeWhere((b) => b.id == id);
      notifyListeners();
    }
    return success;
  }

  void listenActiveBookings() {
    _bookingService.getActiveBookings().listen((list) {
      _activeBookings = list;
      notifyListeners();
    });
  }

  void listenCompletedBookings() {
    _bookingService.getCompletedBookings().listen((list) {
      _completedBookings = list;
      notifyListeners();
    });
  }

  void loadBookings() {
    listenActiveBookings();
    listenCompletedBookings();
  }

  void resetForm() {
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 9, minute: 0);
    _selectedDuration = 2;
    _selectedPayment = 'Cash on Arrival';
    notifyListeners();
  }

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  List<Booking> get currentList =>
      _selectedTab == 0 ? _activeBookings : _completedBookings;
}
