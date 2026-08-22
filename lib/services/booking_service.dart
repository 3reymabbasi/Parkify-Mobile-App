import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import 'parking_service.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ParkingService _parkingService = ParkingService();

  String get _uid => _auth.currentUser!.uid;

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

      await _db.collection('drivers').doc(_uid).update({
        'bookings': FieldValue.increment(1),
        'lastBooking': date,
      });

      // Slot count kam karo
      await _parkingService.decrementByName(parkingName);

      return docRef.id;
    } catch (e) {
      return null;
    }
  }

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
              paymentMethod: data['paymentMethod'] ?? 'Cash on Arrival',
              status: data['status'] ?? 'Active',
              lat: data['lat']?.toString(),
              lng: data['lng']?.toString(),
            );
          }).toList(),
        );
  }

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
              paymentMethod: data['paymentMethod'] ?? 'Cash on Arrival',
              status: data['status'] ?? 'Completed',
              lat: data['lat']?.toString(),
              lng: data['lng']?.toString(),
            );
          }).toList(),
        );
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final doc = await _db.collection('bookings').doc(bookingId).get();
      final parkingName = doc.data()?['parkingName']?.toString() ?? '';

      await _db.collection('bookings').doc(bookingId).update({
        'status': 'Cancelled',
      });

      if (parkingName.isNotEmpty) {
        await _parkingService.incrementByName(parkingName);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

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
