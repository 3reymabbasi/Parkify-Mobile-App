// ============================================================
//  SmartParkify — BookingService
//  Firebase Firestore ke sath booking CRUD operations
//  Add, Get, Cancel, Update booking
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ── ADD NEW BOOKING ────────────────────────────────────────
  Future<String?> addBooking({
    required String parkingName,
    required String address,
    required String date,
    required String time,
    required String slot,
    required String amount,
    required String paymentMethod,
  }) async {
    try {
      final docRef = await _db.collection('bookings').add({
        'driverId': _uid,
        'parkingName': parkingName,
        'address': address,
        'date': date,
        'time': time,
        'slot': slot,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'Active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Driver ka booking count update karo
      await _db.collection('drivers').doc(_uid).update({
        'bookings': FieldValue.increment(1),
        'lastBooking': date,
      });

      return docRef.id; // booking ID return karo
    } catch (e) {
      return null;
    }
  }

  // ── GET DRIVER KI ACTIVE BOOKINGS ─────────────────────────────
  Stream<List<Booking>> getActiveBookings() {
    return _db
        .collection('bookings')
        .where('driverId', isEqualTo: _uid)
        .where('status', isEqualTo: 'Active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Booking(
              id: doc.id,
              parkingName: data['parkingName'] ?? '',
              address: data['address'] ?? '',
              date: data['date'] ?? '',
              time: data['time'] ?? '',
              slot: data['slot'] ?? '',
              amount: data['amount'] ?? '',
              status: data['status'] ?? 'Active',
            );
          }).toList(),
        );
  }

  // ── GET DRIVER KI COMPLETED BOOKINGS ─────────────────────────
  Stream<List<Booking>> getCompletedBookings() {
    return _db
        .collection('bookings')
        .where('driverId', isEqualTo: _uid)
        .where('status', isEqualTo: 'Completed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Booking(
              id: doc.id,
              parkingName: data['parkingName'] ?? '',
              address: data['address'] ?? '',
              date: data['date'] ?? '',
              time: data['time'] ?? '',
              slot: data['slot'] ?? '',
              amount: data['amount'] ?? '',
              status: data['status'] ?? 'Completed',
            );
          }).toList(),
        );
  }

  // ── CANCEL BOOKING ─────────────────────────────────────────
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': 'Cancelled',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── COMPLETE BOOKING (Manager use karta hai) ─────────────────
  Future<bool> completeBooking(String bookingId) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': 'Completed',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── MANAGER: SAARI BOOKINGS GET KARO ─────────────────────────
  Stream<List<Map<String, dynamic>>> getAllBookingsForManager() {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {'id': doc.id, ...data};
          }).toList(),
        );
  }
}
