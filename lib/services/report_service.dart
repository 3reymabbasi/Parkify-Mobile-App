import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── TOTAL REVENUE ──────────────────────────────────────────
  Future<double> getTotalRevenue() async {
    try {
      final snapshot = await _db
          .collection('bookings')
          .where('status', whereIn: ['Active', 'Completed'])
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        final amountStr =
            doc.data()['amount']?.toString().replaceAll(
              RegExp(r'[^0-9.]'),
              '',
            ) ??
            '0';
        total += double.tryParse(amountStr) ?? 0;
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // ── TOTAL BOOKINGS COUNT ───────────────────────────────────
  Future<int> getTotalBookingsCount() async {
    try {
      final snapshot = await _db.collection('bookings').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // ── ACTIVE DRIVERS COUNT ─────────────────────────────────────
  Future<int> getActiveDriversCount() async {
    try {
      final snapshot = await _db
          .collection('drivers')
          .where('status', isEqualTo: 'active')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // ── MONTHLY REVENUE STREAM ────────────────────────────────
  Stream<Map<String, double>> getMonthlyRevenueStream() {
    return _db
        .collection('bookings')
        .where('status', whereIn: ['Active', 'Completed'])
        .snapshots()
        .map((snapshot) {
          final Map<String, double> monthlyRevenue = {};

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final dateStr = data['date']?.toString() ?? '';
            final amountStr =
                data['amount']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ??
                '0';
            final amount = double.tryParse(amountStr) ?? 0;

            final parts = dateStr.split('/');
            if (parts.length >= 2) {
              final months = [
                '',
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              final monthNum = int.tryParse(parts[1]) ?? 1;
              final year = parts.length >= 3 ? parts[2] : '';
              final key = '${months[monthNum]} $year';
              monthlyRevenue[key] = (monthlyRevenue[key] ?? 0) + amount;
            }
          }
          return monthlyRevenue;
        });
  }

  // ── PARKING LOT WISE BOOKINGS ──────────────────────────────
  Future<Map<String, int>> getBookingsByParkingLot() async {
    try {
      final snapshot = await _db.collection('bookings').get();
      final Map<String, int> result = {};

      for (final doc in snapshot.docs) {
        final name = doc.data()['parkingName']?.toString() ?? 'Unknown';
        result[name] = (result[name] ?? 0) + 1;
      }
      return result;
    } catch (e) {
      return {};
    }
  }

  // ── DASHBOARD STATS ───────────────────────────────────────
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final results = await Future.wait([
        getTotalRevenue(),
        getTotalBookingsCount(),
        getActiveDriversCount(),
      ]);

      return {
        'totalRevenue': results[0],
        'totalBookings': results[1],
        'activeDrivers': results[2],
      };
    } catch (e) {
      return {'totalRevenue': 0.0, 'totalBookings': 0, 'activeDrivers': 0};
    }
  }

  // ── DRIVER: SUBMIT ISSUE REPORT ─────────────────────────────
  Future<String?> submitReport({
    required String type,
    required String title,
    required String description,
    required String location,
  }) async {
    try {
      final uid = _auth.currentUser?.uid ?? '';
      final docRef = await _db.collection('reports').add({
        'driverId': uid,
        'type': type,
        'title': title,
        'description': description,
        'location': location,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // ── MANAGER: GET ALL REPORTS ────────────────────────────────
  Stream<List<Map<String, dynamic>>> getAllReports() {
    return _db
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList(),
        );
  }

  // ── MANAGER: UPDATE REPORT STATUS ───────────────────────────
  Future<bool> updateReportStatus(String reportId, String status) async {
    try {
      await _db.collection('reports').doc(reportId).update({'status': status});
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── DRIVER: GET MY REPORTS ──────────────────────────────────
  Stream<List<Map<String, dynamic>>> getMyReports() {
    final uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return Stream.value([]);
    }

    return _db
        .collection('reports')
        .where('driverId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

          // Client side sort (newest first)
          list.sort((a, b) {
            final aTime = a['createdAt'];
            final bTime = b['createdAt'];
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            try {
              return (bTime as dynamic).compareTo(aTime as dynamic);
            } catch (_) {
              return 0;
            }
          });

          return list;
        });
  }
}
