import 'package:latlong2/latlong.dart';

class ParkingSpot {
  final String name;
  final LatLng location;
  final String price;
  final int available;
  final int total;
  String distance;
  final bool isAvailable;

  ParkingSpot({
    required this.name,
    required this.location,
    required this.price,
    required this.available,
    required this.total,
    this.distance = 'Calculating...',
    required this.isAvailable,
  });
}
