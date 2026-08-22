import 'package:flutter/material.dart';
import '../services/parking_service.dart';

class ManagerParkingLotsViewModel extends ChangeNotifier {
  final ParkingService _parkingService = ParkingService();

  List<Map<String, dynamic>> _lots = [];
  bool _loading = false;

  List<Map<String, dynamic>> get lots => List.unmodifiable(_lots);
  bool get loading => _loading;

  int get totalLots => _lots.length;
  int get openLots => _lots.where((l) => l['isAvailable'] == true).length;
  int get fullLots => _lots.where((l) => l['isAvailable'] != true).length;

  void loadLots() {
    _loading = true;
    notifyListeners();

    _parkingService.getAllParkingLotsForManager().listen(
      (list) {
        _lots = list;
        _loading = false;
        notifyListeners();
      },
      onError: (e) {
        _lots = [];
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> toggleAvailability(Map<String, dynamic> lot) async {
    final id = lot['id']?.toString() ?? '';
    if (id.isEmpty) return false;

    final currentlyOpen = lot['isAvailable'] == true;
    final total = lot['total'] is int
        ? lot['total'] as int
        : int.tryParse(lot['total']?.toString() ?? '0') ?? 0;

    if (currentlyOpen) {
      return await _parkingService.updateParkingLot(id, {
        'available': 0,
        'isAvailable': false,
        'status': 'Full',
      });
    } else {
      final reopen = total > 0 ? (total ~/ 2).clamp(1, total) : 1;
      return await _parkingService.updateParkingLot(id, {
        'available': reopen,
        'isAvailable': true,
        'status': 'Open',
      });
    }
  }

  Future<bool> addLot({
    required String name,
    required String address,
    required String price,
    required int total,
    required double lat,
    required double lng,
  }) async {
    return await _parkingService.addParkingLot(
      name: name,
      address: address,
      lat: lat,
      lng: lng,
      price: price,
      totalSpots: total,
    );
  }
}
