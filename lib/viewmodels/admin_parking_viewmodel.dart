import 'package:flutter/material.dart';

class AdminParkingViewModel extends ChangeNotifier {
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

class AdminBookingsViewModel extends ChangeNotifier {
  String _selectedTab = "All";
  String get selectedTab => _selectedTab;

  final List<Map<String, dynamic>> _allBookings = [
    {
      "id": "BK-2026-001234",
      "user": "Ahmed Khan",
      "parking": "Central Mall Parking - Slot A-12",
      "date": "May 3, 2026",
      "time": "09:00 AM - 12:00 PM",
      "duration": "3 hours",
      "amount": "240",
      "status": "active",
      "payment": "paid",
    },
    {
      "id": "BK-2026-001235",
      "user": "Sarah Ali",
      "parking": "City Plaza Parking - Slot B-25",
      "date": "May 3, 2026",
      "time": "10:00 AM - 02:00 PM",
      "duration": "4 hours",
      "amount": "400",
      "status": "completed",
      "payment": "paid",
    },
    {
      "id": "BK-2026-001236",
      "user": "Bilal Ahmed",
      "parking": "Metro Station Parking - Slot C-08",
      "date": "May 3, 2026",
      "time": "03:00 PM - 06:00 PM",
      "duration": "3 hours",
      "amount": "180",
      "status": "upcoming",
      "payment": "paid",
    },
  ];

  List<Map<String, dynamic>> get filteredBookings {
    if (_selectedTab == "All") return _allBookings;
    return _allBookings
        .where((b) => b['status'] == _selectedTab.toLowerCase())
        .toList();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
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

  String getStatusText(String status) =>
      status[0].toUpperCase() + status.substring(1);
}
