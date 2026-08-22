import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../models/parking_spot_model.dart';

class ParkingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── GET ALL PARKING SPOTS (Real-time stream) ───────────────
  Stream<List<ParkingSpot>> getParkingSpots() {
    return _db
        .collection('parking_lots')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final GeoPoint? geoPoint = data['location'];
            return ParkingSpot(
              name: data['name'] ?? '',
              location: geoPoint != null
                  ? LatLng(geoPoint.latitude, geoPoint.longitude)
                  : const LatLng(0, 0),
              price: data['price'] ?? 'Rs 0/hr',
              available: data['available'] ?? 0,
              total: data['total'] ?? 0,
              isAvailable: data['isAvailable'] ?? true,
            );
          }).toList(),
        );
  }

  // ── MANAGER: GET ALL PARKING LOTS ────────────────────────────
  Stream<List<Map<String, dynamic>>> getAllParkingLotsForManager() {
    return _db
        .collection('parking_lots')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList(),
        );
  }

  // ── MANAGER: ADD NEW PARKING LOT ─────────────────────────────
  Future<bool> addParkingLot({
    required String name,
    required String address,
    required double lat,
    required double lng,
    required String price,
    required int totalSpots,
  }) async {
    try {
      await _db.collection('parking_lots').add({
        'name': name,
        'address': address,
        'location': GeoPoint(lat, lng),
        'price': price,
        'total': totalSpots,
        'available': totalSpots, // initially sab available
        'isAvailable': true,
        'status': 'Open',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: UPDATE PARKING LOT ──────────────────────────────
  Future<bool> updateParkingLot(
    String lotId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _db.collection('parking_lots').doc(lotId).update(updates);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: DELETE PARKING LOT ──────────────────────────────
  Future<bool> deleteParkingLot(String lotId) async {
    try {
      await _db.collection('parking_lots').doc(lotId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── UPDATE AVAILABLE SPOTS (jab booking hoti hai) ─────────
  Future<void> decrementAvailableSpots(String lotId) async {
    await _db.collection('parking_lots').doc(lotId).update({
      'available': FieldValue.increment(-1),
    });
  }

  Future<void> incrementAvailableSpots(String lotId) async {
    await _db.collection('parking_lots').doc(lotId).update({
      'available': FieldValue.increment(1),
    });
  }

  // ── DECREMENT / INCREMENT BY NAME (booking flow) ─────────
  Future<void> decrementByName(String parkingName) async {
    try {
      final snap = await _db
          .collection('parking_lots')
          .where('name', isEqualTo: parkingName)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return;
      final doc = snap.docs.first;
      final available = (doc.data()['available'] ?? 0) as int;
      if (available > 0) {
        final next = available - 1;
        await doc.reference.update({
          'available': next,
          if (next <= 0) 'isAvailable': false,
          if (next <= 0) 'status': 'Full',
        });
      }
    } catch (_) {}
  }

  Future<void> incrementByName(String parkingName) async {
    try {
      final snap = await _db
          .collection('parking_lots')
          .where('name', isEqualTo: parkingName)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return;
      final doc = snap.docs.first;
      final data = doc.data();
      final available = (data['available'] ?? 0) as int;
      final total = (data['total'] ?? 0) as int;
      final next = available + 1;
      await doc.reference.update({
        'available': next > total && total > 0 ? total : next,
        'isAvailable': true,
        'status': 'Open',
      });
    } catch (_) {}
  }
}
