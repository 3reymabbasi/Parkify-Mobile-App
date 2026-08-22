import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../services/booking_service.dart';

class ManagerAnalyticsViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();
  final BookingService _bookingService = BookingService();

  bool _loading = true;
  double _totalRevenue = 0;
  int _totalBookings = 0;
  int _activeBookings = 0;
  int _completedBookings = 0;
  int _cancelledBookings = 0;
  Map<String, int> _byParking = {};

  bool get loading => _loading;
  double get totalRevenue => _totalRevenue;
  int get totalBookings => _totalBookings;
  int get activeBookings => _activeBookings;
  int get completedBookings => _completedBookings;
  int get cancelledBookings => _cancelledBookings;
  Map<String, int> get byParking => _byParking;

  String get revenueFormatted {
    if (_totalRevenue >= 1000) {
      return 'Rs. ${(_totalRevenue / 1000).toStringAsFixed(1)}K';
    }
    return 'Rs. ${_totalRevenue.toStringAsFixed(0)}';
  }

  Future<void> loadAnalytics() async {
    _loading = true;
    notifyListeners();

    try {
      final stats = await _reportService.getDashboardStats();
      _totalRevenue = (stats['totalRevenue'] as num?)?.toDouble() ?? 0;
      _totalBookings = (stats['totalBookings'] as int?) ?? 0;

      // Booking counts by status
      _bookingService.getAllBookingsForManager().listen((list) {
        _activeBookings = list
            .where(
              (b) => (b['status']?.toString().toLowerCase() ?? '') == 'active',
            )
            .length;
        _completedBookings = list
            .where(
              (b) =>
                  (b['status']?.toString().toLowerCase() ?? '') == 'completed',
            )
            .length;
        _cancelledBookings = list
            .where(
              (b) =>
                  (b['status']?.toString().toLowerCase() ?? '') == 'cancelled',
            )
            .length;

        // By parking lot
        final map = <String, int>{};
        for (final b in list) {
          final name = b['parkingName']?.toString() ?? 'Unknown';
          map[name] = (map[name] ?? 0) + 1;
        }
        _byParking = map;

        _loading = false;
        notifyListeners();
      });
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }
}
