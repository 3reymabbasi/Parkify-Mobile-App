import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager_reports_viewmodel.dart';

class ManagerReportsView extends StatefulWidget {
  const ManagerReportsView({super.key});

  @override
  State<ManagerReportsView> createState() => _ManagerReportsViewState();
}

class _ManagerReportsViewState extends State<ManagerReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManagerReportsViewModel>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerReportsViewModel>(
      builder: (context, vm, _) {
        final reports = vm.filteredReports;

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
                          'Reports Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _StatCard(
                          title: "${vm.pendingCount}",
                          subtitle: "Pending",
                          icon: Icons.hourglass_top,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          title: "${vm.approvedCount}",
                          subtitle: "Approved",
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          title: "${vm.rejectedCount}",
                          subtitle: "Rejected",
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ["All", "Pending", "Approved", "Rejected"]
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
                        : reports.isEmpty
                        ? const Center(
                            child: Text(
                              'No reports found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: reports.length,
                            itemBuilder: (context, index) =>
                                _ReportCard(report: reports[index], vm: vm),
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

class _ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final ManagerReportsViewModel vm;

  const _ReportCard({required this.report, required this.vm});

  @override
  Widget build(BuildContext context) {
    final status = report['status']?.toString() ?? 'pending';
    final type = report['type']?.toString() ?? 'Other';
    final title = report['title']?.toString() ?? '';
    final description = report['description']?.toString() ?? '';
    final location = report['location']?.toString() ?? '';
    final driverId = report['driverId']?.toString() ?? '';
    final Color statusColor = vm.getStatusColor(status);
    final Color typeColor = vm.getTypeColor(type);
    final bool isPending = status.toLowerCase() == 'pending';

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
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
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
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Divider(height: 24),
            if (driverId.isNotEmpty)
              Text(
                '👤 Driver: ${driverId.length > 12 ? '${driverId.substring(0, 12)}...' : driverId}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '📍 $location',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close, size: 18),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () async {
                        await vm.rejectReport(report);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Report rejected'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      label: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 18),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await vm.approveReport(report);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Report approved'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      label: const Text('Approve'),
                    ),
                  ),
                ],
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
