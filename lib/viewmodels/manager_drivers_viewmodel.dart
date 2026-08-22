import 'package:flutter/material.dart';
import '../services/driver_service.dart';
import '../models/driver_model.dart';

class ManagerDriversViewModel extends ChangeNotifier {
  final DriverService _driverService = DriverService();

  List<DriverModel> _drivers = [];
  bool _loading = false;
  String _filter = 'All';

  List<DriverModel> get drivers {
    if (_filter == 'All') return _drivers;
    return _drivers
        .where((d) => d.status.toLowerCase() == _filter.toLowerCase())
        .toList();
  }

  bool get loading => _loading;
  String get filter => _filter;

  int get totalCount => _drivers.length;
  int get activeCount =>
      _drivers.where((d) => d.status.toLowerCase() == 'active').length;
  int get suspendedCount =>
      _drivers.where((d) => d.status.toLowerCase() == 'suspended').length;

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  void loadDrivers() {
    _loading = true;
    notifyListeners();

    _driverService.getAllDriversStream().listen(
      (list) {
        _drivers = list;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> suspendDriver(String id) async {
    return await _driverService.suspendDriver(id);
  }

  Future<bool> activateDriver(String id) async {
    return await _driverService.activateDriver(id);
  }

  Future<bool> deleteDriver(String id) async {
    return await _driverService.deleteDriver(id);
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
