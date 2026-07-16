// lib/viewmodels/manager_analytics_viewmodel.dart
import 'package:flutter/material.dart';

class ManagerAnalyticsViewModel extends ChangeNotifier {
  String _selectedPeriod = "Monthly";
  String get selectedPeriod => _selectedPeriod;

  final Map<String, List<Map<String, dynamic>>> _revenueByPeriod = {
    "Weekly": [
      {"label": "Mon", "value": 4200.0},
      {"label": "Tue", "value": 5100.0},
      {"label": "Wed", "value": 3800.0},
      {"label": "Thu", "value": 6200.0},
      {"label": "Fri", "value": 7400.0},
      {"label": "Sat", "value": 8900.0},
      {"label": "Sun", "value": 6600.0},
    ],
    "Monthly": [
      {"label": "Jan", "value": 32000.0},
      {"label": "Feb", "value": 28500.0},
      {"label": "Mar", "value": 41200.0},
      {"label": "Apr", "value": 38900.0},
      {"label": "May", "value": 45200.0},
      {"label": "Jun", "value": 49800.0},
    ],
    "Yearly": [
      {"label": "2022", "value": 320000.0},
      {"label": "2023", "value": 410000.0},
      {"label": "2024", "value": 468000.0},
      {"label": "2025", "value": 512000.0},
      {"label": "2026", "value": 235500.0},
    ],
  };

  final List<Map<String, dynamic>> _lotRevenue = [
    {"name": "City Plaza Parking", "revenue": 32400.0, "bookings": 210},
    {"name": "Central Mall Parking", "revenue": 24500.0, "bookings": 168},
    {"name": "Metro Station Parking", "revenue": 18900.0, "bookings": 143},
    {"name": "Airport Parking", "revenue": 0.0, "bookings": 0},
  ];

  List<Map<String, dynamic>> get chartData =>
      _revenueByPeriod[_selectedPeriod]!;

  List<Map<String, dynamic>> get lotRevenue {
    final sorted = List<Map<String, dynamic>>.from(_lotRevenue);
    sorted.sort(
      (a, b) => (b["revenue"] as double).compareTo(a["revenue"] as double),
    );
    return sorted;
  }

  double get totalRevenue =>
      chartData.fold(0.0, (sum, item) => sum + (item["value"] as double));

  double get maxValue => chartData
      .map((e) => e["value"] as double)
      .reduce((a, b) => a > b ? a : b);

  int get totalBookings =>
      _lotRevenue.fold(0, (sum, l) => sum + (l["bookings"] as int));

  double get avgBookingValue =>
      totalBookings == 0 ? 0 : totalRevenue / totalBookings;

  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  double lotPercentage(Map<String, dynamic> lot) {
    final top = lotRevenue.first["revenue"] as double;
    if (top == 0) return 0;
    return (lot["revenue"] as double) / top;
  }
}
