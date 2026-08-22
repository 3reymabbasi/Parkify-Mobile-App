import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager_parking_lots_viewmodel.dart';

class ManagerParkingLotsView extends StatefulWidget {
  const ManagerParkingLotsView({super.key});

  @override
  State<ManagerParkingLotsView> createState() => _ManagerParkingLotsViewState();
}

class _ManagerParkingLotsViewState extends State<ManagerParkingLotsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ManagerParkingLotsViewModel>().loadLots();
    });
  }

  void _showAddLotDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: 'Rs 50/hr');
    final totalCtrl = TextEditingController(text: '40');
    final latCtrl = TextEditingController(text: '33.6844');
    final lngCtrl = TextEditingController(text: '73.0479');
    final formKey = GlobalKey<FormState>();
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Add Parking Lot'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: addressCtrl,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: priceCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Price (e.g. Rs 50/hr)',
                        ),
                      ),
                      TextFormField(
                        controller: totalCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Total Spots',
                        ),
                        validator: (v) {
                          if (v == null || int.tryParse(v) == null) {
                            return 'Enter number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: latCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                      ),
                      TextFormField(
                        controller: lngCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                  ),
                  onPressed: saving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => saving = true);

                          final ok = await context
                              .read<ManagerParkingLotsViewModel>()
                              .addLot(
                                name: nameCtrl.text.trim(),
                                address: addressCtrl.text.trim(),
                                price: priceCtrl.text.trim(),
                                total: int.parse(totalCtrl.text.trim()),
                                lat: double.tryParse(latCtrl.text) ?? 33.6844,
                                lng: double.tryParse(lngCtrl.text) ?? 73.0479,
                              );

                          if (ctx.mounted) Navigator.pop(ctx);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok ? 'Parking lot added' : 'Failed to add',
                                ),
                                backgroundColor: ok ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ManagerParkingLotsViewModel>(
      builder: (context, vm, _) {
        final lots = vm.lots;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF00BFA5),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Lot'),
            onPressed: () => _showAddLotDialog(context),
          ),
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
                          'Parking Lots',
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
                    child: Row(
                      children: [
                        _stat('${vm.totalLots}', 'Total', Colors.blue),
                        const SizedBox(width: 10),
                        _stat('${vm.openLots}', 'Open', Colors.green),
                        const SizedBox(width: 10),
                        _stat('${vm.fullLots}', 'Full', Colors.red),
                      ],
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
                        : lots.isEmpty
                        ? const Center(
                            child: Text(
                              'No parking lots found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: lots.length,
                            itemBuilder: (context, index) {
                              final lot = lots[index];
                              return _LotCard(lot: lot, vm: vm);
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

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _LotCard extends StatelessWidget {
  final Map<String, dynamic> lot;
  final ManagerParkingLotsViewModel vm;

  const _LotCard({required this.lot, required this.vm});

  @override
  Widget build(BuildContext context) {
    final name = lot['name']?.toString() ?? 'Unknown';
    final address = lot['address']?.toString() ?? '';
    final price = lot['price']?.toString() ?? '';
    final available = lot['available'] ?? 0;
    final total = lot['total'] ?? 0;
    final isOpen = lot['isAvailable'] == true;
    final status = lot['status']?.toString() ?? (isOpen ? 'Open' : 'Full');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: (isOpen ? Colors.green : Colors.red).withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isOpen ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                address,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Slots: $available / $total  •  $price',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOpen ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final ok = await vm.toggleAvailability(lot);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? (isOpen ? 'Marked as Full' : 'Marked as Open')
                              : 'Update failed',
                        ),
                        backgroundColor: ok ? Colors.teal : Colors.red,
                      ),
                    );
                  }
                },
                child: Text(isOpen ? 'Mark as Full' : 'Mark as Open'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
