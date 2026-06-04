// ============================================================
//  SmartParkify — NotificationService
//  Local notifications — booking confirmations, reminders
//  (Firebase Cloud Messaging future mein add kar sakte hain)
// ============================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── INITIALIZE ─────────────────────────────────────────────
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
  }

  // ── BOOKING CONFIRM NOTIFICATION ────────────────────────────
  Future<void> showBookingConfirmed({
    required String parkingName,
    required String date,
    required String time,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'booking_channel',
        'Booking Notifications',
        channelDescription: 'SmartParkify booking updates',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      0,
      '✅ Booking Confirmed!',
      '$parkingName — $date at $time',
      details,
    );
  }

  // ── BOOKING REMINDER ───────────────────────────────────────
  Future<void> showBookingReminder(String parkingName) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Parking reminders',
        importance: Importance.defaultImportance,
      ),
    );

    await _plugin.show(
      1,
      '⏰ Parking Reminder',
      'Your booking at $parkingName starts in 30 minutes',
      details,
    );
  }
}
