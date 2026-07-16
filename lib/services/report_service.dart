// ============================================================
//  SmartParkify — ReportService
//  Manager ke liye revenue aur booking reports
//  Firestore se aggregate data nikalna
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // ── MONTHLY REVENUE STREAM (Real-time) ────────────────────
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

            // Simple month key: "May 2026" format
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

  // ── DASHBOARD STATS (saab ek saath) ───────────────────────
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
}
