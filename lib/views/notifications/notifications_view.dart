import 'package:flutter/material.dart';

// ── Simple local model for now ──────────────────────────────
// Jab Firebase lag jayega to yeh Firestore ke "notifications"
// collection se real-time stream hoga (jaisa ERD mein hai).
class NotificationItem {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  // Abhi ke liye static demo data — Firebase phase mein
  // NotificationService/Firestore stream se replace hoga
  static const List<NotificationItem> _demoNotifications = [
    NotificationItem(
      icon: Icons.check_circle_outline,
      title: 'Booking Confirmed',
      message: 'Your slot at Centaurus Mall Parking is booked for today.',
      time: '10 min ago',
    ),
    NotificationItem(
      icon: Icons.access_time_rounded,
      title: 'Parking Reminder',
      message: 'Your booking at F-7 Markaz Parking starts in 30 minutes.',
      time: '1 hour ago',
    ),
    NotificationItem(
      icon: Icons.flag_outlined,
      title: 'Report Update',
      message: 'Your submitted issue report is under review.',
      time: 'Yesterday',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _demoNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _demoNotifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _demoNotifications[index];
                return _buildNotificationTile(item);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00796B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: const Color(0xFF00796B)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                Text(
                  item.time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF00796B),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
