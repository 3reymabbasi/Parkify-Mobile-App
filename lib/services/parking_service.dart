// ============================================================
//  SmartParkify — ParkingService
//  Firebase Firestore se parking lots data manage karo
//  Admin: Add, Update, Delete | User: Get all spots
// ============================================================

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

  // ── ADMIN: GET ALL PARKING LOTS ────────────────────────────
  Stream<List<Map<String, dynamic>>> getAllParkingLotsForAdmin() {
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

  // ── ADMIN: ADD NEW PARKING LOT ─────────────────────────────
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

  // ── ADMIN: UPDATE PARKING LOT ──────────────────────────────
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

  // ── ADMIN: DELETE PARKING LOT ──────────────────────────────
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
}
