import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_parking_viewmodel.dart';

class AdminParkingLotsView extends StatelessWidget {
  const AdminParkingLotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminParkingViewModel(),
      child: const _AdminParkingLotsBody(),
    );
  }
}

class _AdminParkingLotsBody extends StatelessWidget {
  const _AdminParkingLotsBody();

  void _showAddEditDialog(
    BuildContext context,
    AdminParkingViewModel vm, {
    int? index,
  }) {
    final lot = index != null ? vm.parkingLots[index] : null;
    showDialog(
      context: context,
      builder: (_) => _AddEditParkingLotDialog(
        existingLot: lot,
        onSave: (newLot) {
          if (index != null) {
            vm.updateLot(index, newLot);
          } else {
            vm.addLot(newLot);
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                index != null
                    ? "Parking Lot Updated Successfully"
                    : "New Parking Lot Added",
              ),
              backgroundColor: const Color(0xFF00796B),
            ),
          );
        },
      ),
    );
  }

  void _deleteLot(BuildContext context, AdminParkingViewModel vm, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Parking Lot?"),
        content: Text(
          "Are you sure you want to delete ${vm.parkingLots[index]['name']}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              vm.deleteLot(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Parking Lot Deleted")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminParkingViewModel>(
      builder: (context, vm, _) {
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
                  // Header
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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => _showAddEditDialog(context, vm),
                        ),
                      ],
                    ),
                  ),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildStatCard("5", "Total Lots"),
                        const SizedBox(width: 12),
                        _buildStatCard("497", "Occupied"),
                        const SizedBox(width: 12),
                        _buildStatCard("Rs. 104.5K", "Today"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Lots List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vm.parkingLots.length,
                      itemBuilder: (context, index) {
                        final lot = vm.parkingLots[index];
                        return _ParkingLotCard(
                          lot: lot,
                          vm: vm,
                          index: index,
                          onEdit: () =>
                              _showAddEditDialog(context, vm, index: index),
                          onDelete: () => _deleteLot(context, vm, index),
                        );
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

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Parking Lot Card ───────────────────────────────────────
class _ParkingLotCard extends StatelessWidget {
  final Map<String, dynamic> lot;
  final AdminParkingViewModel vm;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ParkingLotCard({
    required this.lot,
    required this.vm,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = vm.getStatusColor(lot["status"]);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 6,
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
                    lot["name"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (lot["status"] as String).toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              lot["address"],
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Occupancy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Occupancy",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${lot['occupancy']} (${lot['percentage']}%)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (lot['percentage'] as int) / 100,
                backgroundColor: Colors.grey.shade300,
                color: (lot['percentage'] as int) > 90
                    ? Colors.red
                    : const Color(0xFF00796B),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),

            // Price & Timing
            Row(
              children: [
                Text(
                  "Rs. ${lot['price']}/hour   ",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.access_time, size: 20, color: Colors.black),
                Text(
                  " ${lot['timing']}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amenities
            Wrap(
              spacing: 8,
              children: (lot['amenities'] as List<dynamic>)
                  .map(
                    (a) => Chip(
                      label: Text(
                        a.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  )
                  .toList(),
            ),

            const Divider(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A2540),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onEdit,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add / Edit Dialog ──────────────────────────────────────
class _AddEditParkingLotDialog extends StatefulWidget {
  final Map<String, dynamic>? existingLot;
  final Function(Map<String, dynamic>) onSave;

  const _AddEditParkingLotDialog({this.existingLot, required this.onSave});

  @override
  State<_AddEditParkingLotDialog> createState() =>
      _AddEditParkingLotDialogState();
}

class _AddEditParkingLotDialogState extends State<_AddEditParkingLotDialog> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController slotsController;
  late TextEditingController priceController;
  late TextEditingController latController;
  late TextEditingController longController;

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  final Map<String, bool> amenities = {
    "CCTV": true,
    "Security": true,
    "Valet": false,
    "EV Charging": false,
    "Car Wash": false,
    "Shuttle": false,
  };

  @override
  void initState() {
    super.initState();
    final lot = widget.existingLot;
    nameController = TextEditingController(text: lot?['name'] ?? '');
    addressController = TextEditingController(text: lot?['address'] ?? '');
    slotsController = TextEditingController(
      text: lot?['totalSlots']?.toString() ?? '150',
    );
    priceController = TextEditingController(text: lot?['price'] ?? '80');
    latController = TextEditingController(text: lot?['lat'] ?? '31.5204');
    longController = TextEditingController(text: lot?['long'] ?? '74.3587');
    openingTime = const TimeOfDay(hour: 8, minute: 0);
    closingTime = const TimeOfDay(hour: 22, minute: 0);

    // Pre-fill amenities if editing
    if (lot != null) {
      final existingAmenities = lot['amenities'] as List<dynamic>? ?? [];
      for (final key in amenities.keys) {
        amenities[key] = existingAmenities.contains(key);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    slotsController.dispose();
    priceController.dispose();
    latController.dispose();
    longController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isOpening) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpening
          ? (openingTime ?? const TimeOfDay(hour: 8, minute: 0))
          : (closingTime ?? const TimeOfDay(hour: 22, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          openingTime = picked;
        } else {
          closingTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existingLot == null
                  ? "Add New Parking Lot"
                  : "Edit Parking Lot",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2540),
              ),
            ),
            const SizedBox(height: 24),

            _buildTextField("Parking Lot Name", nameController),
            const SizedBox(height: 12),
            _buildTextField("Full Address", addressController),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Total Slots",
                    slotsController,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    "Price/Hour (Rs.)",
                    priceController,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time pickers
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Opening Time",
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      openingTime?.format(context) ?? "--:--",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onTap: () => _pickTime(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Closing Time",
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      closingTime?.format(context) ?? "--:--",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildTextField("Latitude", latController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("Longitude", longController)),
              ],
            ),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Amenities",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ...amenities.keys.map(
              (key) => SwitchListTile(
                title: Text(key, style: const TextStyle(color: Colors.black)),
                value: amenities[key]!,
                onChanged: (val) => setState(() => amenities[key] = val),
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF00796B),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final newLot = {
                        "name": nameController.text.isEmpty
                            ? "New Parking Lot"
                            : nameController.text,
                        "address": addressController.text,
                        "status": "active",
                        "occupancy": "0/${slotsController.text}",
                        "percentage": 0,
                        "price": priceController.text,
                        "timing":
                            "${openingTime?.format(context) ?? '08:00'} - ${closingTime?.format(context) ?? '22:00'}",
                        "revenue": "0",
                        "totalSlots": int.tryParse(slotsController.text) ?? 150,
                        "lat": latController.text,
                        "long": longController.text,
                        "amenities": amenities.entries
                            .where((e) => e.value)
                            .map((e) => e.key)
                            .toList(),
                      };
                      widget.onSave(newLot);
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}
