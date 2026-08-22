import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ManagerReportsViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  String _selectedTab = "All";
  String get selectedTab => _selectedTab;

  List<Map<String, dynamic>> _reports = [];
  bool _loading = false;

  bool get loading => _loading;

  List<Map<String, dynamic>> get filteredReports {
    if (_selectedTab == "All") return _reports;
    return _reports
        .where(
          (r) =>
              (r['status']?.toString().toLowerCase() ?? '') ==
              _selectedTab.toLowerCase(),
        )
        .toList();
  }

  int get pendingCount =>
      _reports.where((r) => r['status'] == 'pending').length;
  int get approvedCount =>
      _reports.where((r) => r['status'] == 'approved').length;
  int get rejectedCount =>
      _reports.where((r) => r['status'] == 'rejected').length;

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void loadReports() {
    _loading = true;
    notifyListeners();

    _reportService.getAllReports().listen(
      (list) {
        _reports = list;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<void> approveReport(Map<String, dynamic> report) async {
    final id = report['id']?.toString();
    if (id == null) return;
    await _reportService.updateReportStatus(id, 'approved');
  }

  Future<void> rejectReport(Map<String, dynamic> report) async {
    final id = report['id']?.toString();
    if (id == null) return;
    await _reportService.updateReportStatus(id, 'rejected');
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'Theft':
        return Colors.red;
      case 'Slot Issue':
        return Colors.purple;
      case 'Payment Issue':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  String getStatusText(String status) {
    if (status.isEmpty) return 'Unknown';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}
