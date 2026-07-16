// lib/viewmodels/manager_reports_viewmodel.dart
import 'package:flutter/material.dart';

class ManagerReportsViewModel extends ChangeNotifier {
  String _selectedTab = "All";
  String get selectedTab => _selectedTab;

  final List<Map<String, dynamic>> _reports = [
    {
      "id": "RPT-2026-0091",
      "type": "Theft",
      "title": "Car mirror stolen",
      "description":
          "Found my side mirror missing after picking up my car from Slot A-12. No CCTV footage available at that angle.",
      "driver": "Ahmed Khan",
      "lot": "Central Mall Parking - Slot A-12",
      "date": "May 3, 2026",
      "hasEvidence": true,
      "status": "pending",
    },
    {
      "id": "RPT-2026-0092",
      "type": "Slot Issue",
      "title": "Slot already occupied",
      "description":
          "Booked Slot B-25 but another car was already parked there when I arrived. Had to park elsewhere.",
      "driver": "Sarah Ali",
      "lot": "City Plaza Parking - Slot B-25",
      "date": "May 2, 2026",
      "hasEvidence": false,
      "status": "pending",
    },
    {
      "id": "RPT-2026-0088",
      "type": "Payment Issue",
      "title": "Charged twice for same booking",
      "description":
          "Payment was deducted twice from my card for a single booking. Please refund the extra amount.",
      "driver": "Imran Baig",
      "lot": "Metro Station Parking - Slot C-08",
      "date": "April 29, 2026",
      "hasEvidence": true,
      "status": "approved",
    },
    {
      "id": "RPT-2026-0085",
      "type": "Other",
      "title": "Navigation route was incorrect",
      "description":
          "The in-app route took me to the wrong entrance of the parking lot, causing a delay.",
      "driver": "Fatima Noor",
      "lot": "Airport Parking - Slot D-14",
      "date": "April 25, 2026",
      "hasEvidence": false,
      "status": "rejected",
    },
  ];

  List<Map<String, dynamic>> get filteredReports {
    if (_selectedTab == "All") return _reports;
    return _reports
        .where((r) => r["status"] == _selectedTab.toLowerCase())
        .toList();
  }

  int get pendingCount =>
      _reports.where((r) => r["status"] == "pending").length;
  int get approvedCount =>
      _reports.where((r) => r["status"] == "approved").length;
  int get rejectedCount =>
      _reports.where((r) => r["status"] == "rejected").length;

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  // Approve/Reject Report use case -> triggers Send Notification (mocked)
  void approveReport(Map<String, dynamic> report) {
    final index = _reports.indexOf(report);
    if (index != -1) {
      _reports[index]["status"] = "approved";
      notifyListeners();
    }
  }

  void rejectReport(Map<String, dynamic> report) {
    final index = _reports.indexOf(report);
    if (index != -1) {
      _reports[index]["status"] = "rejected";
      notifyListeners();
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case "Theft":
        return Colors.red;
      case "Slot Issue":
        return Colors.purple;
      case "Payment Issue":
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  String getStatusText(String status) =>
      status[0].toUpperCase() + status.substring(1);
}
