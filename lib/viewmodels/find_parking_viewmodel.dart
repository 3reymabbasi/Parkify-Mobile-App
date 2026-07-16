import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/parking_spot_model.dart';

class FindParkingViewModel extends ChangeNotifier {
  LatLng? _driverLocation;
  bool _loadingLocation = false;
  String? _locationError;

  LatLng? get driverLocation => _driverLocation;
  bool get loadingLocation => _loadingLocation;
  String? get locationError => _locationError;

  final List<ParkingSpot> _allSpots = [
    ParkingSpot(
      name: 'Centaurus Mall Parking',
      location: const LatLng(33.6844, 73.0479),
      price: 'Rs 50/hr',
      available: 24,
      total: 50,
      isAvailable: true,
    ),
    ParkingSpot(
      name: 'F-7 Markaz Parking',
      location: const LatLng(33.6910, 73.0550),
      price: 'Rs 40/hr',
      available: 12,
      total: 40,
      isAvailable: true,
    ),
    ParkingSpot(
      name: 'G-9 Markaz Parking',
      location: const LatLng(33.6750, 73.0100),
      price: 'Rs 35/hr',
      available: 0,
      total: 25,
      isAvailable: false,
    ),
    ParkingSpot(
      name: 'Blue Area Parking',
      location: const LatLng(33.6800, 73.0300),
      price: 'Rs 55/hr',
      available: 18,
      total: 35,
      isAvailable: true,
    ),
    ParkingSpot(
      name: 'Jinnah Super Parking',
      location: const LatLng(33.7100, 73.0600),
      price: 'Rs 30/hr',
      available: 28,
      total: 30,
      isAvailable: true,
    ),
  ];

  List<ParkingSpot> _sortedSpots = [];
  List<ParkingSpot> get sortedSpots => _sortedSpots;

  FindParkingViewModel() {
    _sortedSpots = List.from(_allSpots);
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
    if (_driverLocation == null) return;

    final distance = Distance();
    _sortedSpots = List.from(_allSpots);

    _sortedSpots.sort((a, b) {
      final distA = distance.as(
        LengthUnit.Kilometer,
        _driverLocation!,
        a.location,
      );
      final distB = distance.as(
        LengthUnit.Kilometer,
        _driverLocation!,
        b.location,
      );
      return distA.compareTo(distB);
    });

    for (var spot in _sortedSpots) {
      final dist = distance.as(
        LengthUnit.Kilometer,
        _driverLocation!,
        spot.location,
      );
      spot.distance = '${dist.toStringAsFixed(1)} km';
    }

    notifyListeners();
  }
}
