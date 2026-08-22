import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class ManagerParkingViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _parkingLots = [
    {
      "name": "Central Mall Parking",
      "address": "Main Boulevard, Gulberg III, Lahore",
      "status": "active",
      "occupancy": "98/150",
      "percentage": 65,
      "price": "80",
      "timing": "08:00 - 22:00",
      "revenue": "24,500",
      "totalSlots": 150,
      "lat": "31.5204",
      "long": "74.3587",
      "amenities": ["CCTV", "Security", "EV Charging"],
    },
    {
      "name": "City Plaza Parking",
      "address": "MM Alam Road, Gulberg, Lahore",
      "status": "full",
      "occupancy": "120/120",
      "percentage": 100,
      "price": "100",
      "timing": "07:00 - 23:00",
      "revenue": "32,400",
      "totalSlots": 120,
      "lat": "31.5150",
      "long": "74.3430",
      "amenities": ["CCTV", "Valet", "Car Wash"],
    },
    {
      "name": "Metro Station Parking",
      "address": "Metro Station, Johar Town, Lahore",
      "status": "active",
      "occupancy": "145/200",
      "percentage": 73,
      "price": "60",
      "timing": "06:00 - 00:00",
      "revenue": "18,900",
      "totalSlots": 200,
      "lat": "31.4724",
      "long": "74.2728",
      "amenities": ["CCTV", "Security"],
    },
    {
      "name": "Airport Parking",
      "address": "Allama Iqbal International Airport, Lahore",
      "status": "maintenance",
      "occupancy": "0/300",
      "percentage": 0,
      "price": "120",
      "timing": "00:00 - 23:59",
      "revenue": "0",
      "totalSlots": 300,
      "lat": "31.5216",
      "long": "74.4036",
      "amenities": ["CCTV", "Security", "Shuttle", "EV Charging"],
    },
  ];

  List<Map<String, dynamic>> get parkingLots => List.unmodifiable(_parkingLots);

  Color getStatusColor(String status) {
    if (status == "active") return Colors.green;
    if (status == "full") return Colors.orange;
    return Colors.red;
  }

  void addLot(Map<String, dynamic> lot) {
    _parkingLots.add(lot);
    notifyListeners();
  }

  void updateLot(int index, Map<String, dynamic> lot) {
    _parkingLots[index] = lot;
    notifyListeners();
  }

  void deleteLot(int index) {
    _parkingLots.removeAt(index);
    notifyListeners();
  }
}

class ManagerBookingsViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  List<Map<String, dynamic>> get allBookings => List.unmodifiable(_allBookings);

  String _selectedTab = "All";
  String get selectedTab => _selectedTab;

  List<Map<String, dynamic>> _allBookings = [];
  bool _loading = false;

  bool get loading => _loading;

  List<Map<String, dynamic>> get filteredBookings {
    if (_selectedTab == "All") return _allBookings;
    return _allBookings
        .where(
          (b) =>
              (b['status']?.toString().toLowerCase() ?? '') ==
              _selectedTab.toLowerCase(),
        )
        .toList();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void loadBookings() {
    _loading = true;
    notifyListeners();

    _bookingService.getAllBookingsForManager().listen(
      (list) {
        _allBookings = list;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> completeBooking(String bookingId) async {
    final success = await _bookingService.completeBooking(bookingId);
    return success;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Colors.green;
      case "completed":
        return Colors.blue;
      case "upcoming":
        return Colors.purple;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    if (status.isEmpty) return 'Unknown';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}
