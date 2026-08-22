import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/parking_spot_model.dart';
import '../services/parking_service.dart';

class FindParkingViewModel extends ChangeNotifier {
  final ParkingService _parkingService = ParkingService();

  LatLng? _driverLocation;
  bool _loadingLocation = false;
  bool _loadingSpots = false;
  String? _locationError;

  LatLng? get driverLocation => _driverLocation;
  bool get loadingLocation => _loadingLocation;
  bool get loadingSpots => _loadingSpots;
  String? get locationError => _locationError;

  List<ParkingSpot> _sortedSpots = [];
  List<ParkingSpot> get sortedSpots => _sortedSpots;

  // ── Load parking spots from Firestore ─────────────────────
  void loadParkingSpots() {
    _loadingSpots = true;
    notifyListeners();

    _parkingService.getParkingSpots().listen(
      (spots) {
        _sortedSpots = spots;
        _loadingSpots = false;

        if (_driverLocation != null) {
          _updateDistancesAndSort();
        } else {
          notifyListeners();
        }
      },
      onError: (e) {
        _loadingSpots = false;
        notifyListeners();
      },
    );
  }

  Future<void> getDriverLocation(BuildContext context) async {
    _loadingLocation = true;
    _locationError = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Location services are disabled';
        _loadingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Location permissions permanently denied';
        _loadingLocation = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _driverLocation = LatLng(position.latitude, position.longitude);
      _loadingLocation = false;
      notifyListeners();

      _updateDistancesAndSort();
    } catch (e) {
      _locationError = 'Location error: $e';
      _loadingLocation = false;
      notifyListeners();
    }
  }

  void _updateDistancesAndSort() {
    if (_driverLocation == null || _sortedSpots.isEmpty) return;

    final distance = Distance();

    for (var spot in _sortedSpots) {
      final dist = distance.as(
        LengthUnit.Kilometer,
        _driverLocation!,
        spot.location,
      );
      spot.distance = '${dist.toStringAsFixed(1)} km';
    }

    _sortedSpots.sort((a, b) {
      final distA = double.tryParse(a.distance.replaceAll(' km', '')) ?? 999;
      final distB = double.tryParse(b.distance.replaceAll(' km', '')) ?? 999;
      return distA.compareTo(distB);
    });

    notifyListeners();
  }
}
