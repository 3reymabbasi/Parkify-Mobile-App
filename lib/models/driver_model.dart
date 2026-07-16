class DriverModel {
  final String initials;
  final String name;
  final String email;
  final String phone;
  final String joined;
  final int bookings;
  final String spent;
  final String lastBooking;
  String status; // active | suspended

  DriverModel({
    required this.initials,
    required this.name,
    required this.email,
    required this.phone,
    required this.joined,
    required this.bookings,
    required this.spent,
    required this.lastBooking,
    required this.status,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      initials: map['initials'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      joined: map['joined'] ?? '',
      bookings: map['bookings'] ?? 0,
      spent: map['spent'] ?? '0',
      lastBooking: map['lastBooking'] ?? '',
      status: map['status'] ?? 'active',
    );
  }
}
