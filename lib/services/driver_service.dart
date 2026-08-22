import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/driver_model.dart';

class DriverService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── GET CURRENT DRIVER PROFILE ───────────────────────────────
  Future<Map<String, dynamic>?> getDriverProfile() async {
    try {
      final doc = await _db.collection('drivers').doc(_uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── REAL-TIME DRIVER PROFILE STREAM ─────────────────────────
  Stream<Map<String, dynamic>?> getDriverProfileStream() {
    return _db.collection('drivers').doc(_uid).snapshots().map((doc) {
      if (doc.exists) return doc.data();
      return null;
    });
  }

  // ── UPDATE PROFILE ─────────────────────────────────────────
  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      await _db.collection('drivers').doc(_uid).update({
        'name': name,
        'phone': phone,
        'initials': _getInitials(name),
      });

      // Firebase Auth display name bhi update karo
      await _auth.currentUser!.updateDisplayName(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: GET ALL DRIVERS ───────────────────────────────────
  Stream<List<DriverModel>> getAllDriversStream() {
    return _db
        .collection('drivers')
        .where('role', isEqualTo: 'driver')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return DriverModel.fromMap({...data, 'uid': doc.id});
          }).toList(),
        );
  }

  // ── MANAGER: SUSPEND DRIVER ────────────────────────────────────
  Future<bool> suspendDriver(String driverId) async {
    try {
      await _db.collection('drivers').doc(driverId).update({
        'status': 'suspended',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: ACTIVATE DRIVER ───────────────────────────────────
  Future<bool> activateDriver(String driverId) async {
    try {
      await _db.collection('drivers').doc(driverId).update({
        'status': 'active',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: DELETE DRIVER ─────────────────────────────────────
  Future<bool> deleteDriver(String driverId) async {
    try {
      await _db.collection('drivers').doc(driverId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Helper ─────────────────────────────────────────────────
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 2).toUpperCase();
  }
}
