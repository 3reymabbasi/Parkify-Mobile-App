import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager_parking_viewmodel.dart';

class ManagerBookingsView extends StatefulWidget {
  const ManagerBookingsView({super.key});

  @override
  State<ManagerBookingsView> createState() => _ManagerBookingsViewState();
}

class _ManagerBookingsViewState extends State<ManagerBookingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManagerBookingsViewModel>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerBookingsViewModel>(
      builder: (context, vm, _) {
        final bookings = vm.filteredBookings;

        final total = vm.allBookings.length;
        final active = vm.allBookings
            .where(
              (b) => (b['status']?.toString().toLowerCase() ?? '') == 'active',
            )
            .length;
        final completed = vm.allBookings
            .where(
              (b) =>
                  (b['status']?.toString().toLowerCase() ?? '') == 'completed',
            )
            .length;
        final cancelled = vm.allBookings
            .where(
              (b) =>
                  (b['status']?.toString().toLowerCase() ?? '') == 'cancelled',
            )
            .length;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A2540), Color(0xFF00796B)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Bookings',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      children: [
                        _StatCard(
                          title: '$total',
                          subtitle: 'Total Bookings',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          title: '$active',
                          subtitle: 'Active Now',
                          icon: Icons.timer,
                          color: Colors.green,
                        ),
                        _StatCard(
                          title: '$completed',
                          subtitle: 'Completed',
                          icon: Icons.check_circle,
                          color: Colors.purple,
                        ),
                        _StatCard(
                          title: '$cancelled',
                          subtitle: 'Cancelled',
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', 'Active', 'Completed', 'Cancelled']
                            .map((tab) {
                              final bool selected = vm.selectedTab == tab;
                              return GestureDetector(
                                onTap: () => vm.setTab(tab),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF0A2540)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    tab,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: vm.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : bookings.isEmpty
                        ? const Center(
                            child: Text(
                              'No bookings found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              return _BookingCard(booking: booking, vm: vm);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final ManagerBookingsViewModel vm;

  const _BookingCard({required this.booking, required this.vm});

  @override
  Widget build(BuildContext context) {
    final status = booking['status']?.toString() ?? 'Active';
    final Color statusColor = vm.getStatusColor(status);
    final id = booking['id']?.toString() ?? '';
    final parking = booking['parkingName']?.toString() ?? 'Unknown';
    final date = booking['date']?.toString() ?? '';
    final time = booking['time']?.toString() ?? '';
    final amount = booking['amount']?.toString() ?? '0';
    final slot = booking['slot']?.toString() ?? '';
    final payment = booking['paymentMethod']?.toString() ?? 'Cash on Arrival';
    final driverId = booking['driverId']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    id.length > 12 ? '${id.substring(0, 12)}...' : id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    vm.getStatusText(status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '📍 $parking',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            if (slot.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '🅿️ Slot: $slot',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              '📅 $date • $time',
              style: const TextStyle(color: Colors.black87),
            ),
            if (driverId.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '👤 Driver: ${driverId.length > 10 ? '${driverId.substring(0, 10)}...' : driverId}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      amount.contains('Rs') ? amount : 'Rs. $amount',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00796B),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Payment',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      payment,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (status.toLowerCase() == 'active') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final ok = await vm.completeBooking(id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok ? 'Marked as Completed' : 'Failed to update',
                          ),
                          backgroundColor: ok ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Complete'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
