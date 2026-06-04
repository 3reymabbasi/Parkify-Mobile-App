import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/booking_viewmodel.dart';
import 'booking_confirmation_view.dart';

class BookingView extends StatelessWidget {
  final String parkingName;
  final String price;

  const BookingView({
    super.key,
    required this.parkingName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, vm, _) {
        final String formattedDate = DateFormat(
          'MMM d, yyyy',
        ).format(vm.selectedDate);
        final String formattedTime = vm.selectedTime.format(context);
        final double total = vm.calculateTotal(price);

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: const Color(0xFF00796B),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Parking',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  parkingName,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available Slots Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Slots',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            '24/50',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BFA5),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildAmenity(Icons.camera_alt, 'CCTV'),
                          const SizedBox(width: 12),
                          _buildAmenity(Icons.security, 'Secure'),
                          const SizedBox(width: 12),
                          _buildAmenity(Icons.access_time, '24/7'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Select Date
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: vm.selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF00BFA5),
                            onPrimary: Colors.white,
                            onSurface: Colors.black87,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) vm.setDate(picked);
                  },
                  child: _buildSelectionTile(
                    formattedDate,
                    Icons.calendar_today,
                  ),
                ),

                const SizedBox(height: 24),

                // Start Time
                const Text(
                  'Start Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: vm.selectedTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF00BFA5),
                            onPrimary: Colors.white,
                            onSurface: Colors.black87,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) vm.setTime(picked);
                  },
                  child: _buildSelectionTile(formattedTime, Icons.access_time),
                ),

                const SizedBox(height: 24),

                // Duration
                const Text(
                  'Duration (Hours)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.durationOptions.map((hours) {
                    final bool isSelected = hours == vm.selectedDuration;
                    return GestureDetector(
                      onTap: () => vm.setDuration(hours),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00BFA5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '${hours}h',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Price Breakdown
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00796B), Color(0xFF004D40)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Price Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPriceRow('Hourly Rate', price),
                      _buildPriceRow(
                        'Duration',
                        '${vm.selectedDuration} hours',
                      ),
                      const Divider(color: Colors.white24),
                      _buildPriceRow(
                        'Subtotal',
                        'Rs ${vm.calculateSubtotal(price).toStringAsFixed(0)}',
                      ),
                      _buildPriceRow(
                        'Tax (10%)',
                        'Rs ${vm.calculateTax(price).toStringAsFixed(0)}',
                      ),
                      const Divider(color: Colors.white24),
                      _buildPriceRow(
                        'Total',
                        'Rs ${total.toStringAsFixed(0)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Payment Method
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildPaymentOption(vm, 'Cash on Arrival', Icons.money),
                      _buildPaymentOption(
                        vm,
                        'Bank Transfer',
                        Icons.account_balance,
                      ),
                      _buildPaymentOption(
                        vm,
                        'EasyPaisa / JazzCash',
                        Icons.phone_android,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Confirm Booking Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      vm.addActiveBooking(
                        parkingName: parkingName,
                        date: formattedDate,
                        time: formattedTime,
                        amount: '₹${total.toStringAsFixed(0)}',
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationView(
                            parkingName: parkingName,
                            date: formattedDate,
                            time: formattedTime,
                            slot: 'A-12',
                            amount: '₹${total.toStringAsFixed(0)}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionTile(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF00BFA5)),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Color(0xFF00BFA5)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.white : Colors.white70,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BookingViewModel vm, String title, IconData icon) {
    final bool isSelected = vm.selectedPayment == title;
    return GestureDetector(
      onTap: () => vm.setPayment(title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00BFA5).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00BFA5) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00BFA5) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF00BFA5)),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF00BFA5), size: 26),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
