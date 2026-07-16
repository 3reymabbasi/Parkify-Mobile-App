class Booking {
  final String id;
  final String parkingName;
  final String address;
  final String date;
  final String time;
  final String slot;
  final String amount;
  final String
  paymentMethod; // Cash on Arrival, Bank Transfer, EasyPaisa / JazzCash
  final String status; // Active, Upcoming, Completed, Cancelled

  Booking({
    required this.id,
    required this.parkingName,
    required this.address,
    required this.date,
    required this.time,
    required this.slot,
    required this.amount,
    this.paymentMethod = 'Cash on Arrival',
    this.status = 'Active',
  });

  factory Booking.fromMap(Map<String, String> map) {
    return Booking(
      id: map['id'] ?? '',
      parkingName: map['location'] ?? '',
      address: map['address'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      slot: map['slot'] ?? '',
      amount: map['amount'] ?? '',
      paymentMethod: map['paymentMethod'] ?? 'Cash on Arrival',
      status: map['status'] ?? 'Active',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'location': parkingName,
      'address': address,
      'date': date,
      'time': time,
      'slot': slot,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}
