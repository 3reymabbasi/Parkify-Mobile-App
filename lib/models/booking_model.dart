class Booking {
  final String id;
  final String parkingName;
  final String address;
  final String date;
  final String time;
  final String slot;
  final String amount;
  final String paymentMethod;
  final String status;
  final String? lat;
  final String? lng;
  // Constructor
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
    this.lat,
    this.lng,
  });

  // Convenience getter
  String get location => parkingName;

  // Factory Constructor
  factory Booking.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Booking(
      id: docId ?? map['id']?.toString() ?? '',
      parkingName:
          map['parkingName']?.toString() ?? map['location']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      slot: map['slot']?.toString() ?? '',
      amount: map['amount']?.toString() ?? '',
      paymentMethod: map['paymentMethod']?.toString() ?? 'Cash on Arrival',
      status: map['status']?.toString() ?? 'Active',
      lat: map['lat']?.toString(),
      lng: map['lng']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parkingName': parkingName,
      'address': address,
      'date': date,
      'time': time,
      'slot': slot,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }
}
