class DriverModel {
  final String id;
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
    required this.id,
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
      id: map['uid']?.toString() ?? map['id']?.toString() ?? '',
      initials: map['initials']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      joined: map['joined']?.toString() ?? '',
      bookings: map['bookings'] is int
          ? map['bookings']
          : int.tryParse(map['bookings']?.toString() ?? '0') ?? 0,
      spent: map['spent']?.toString() ?? '0',
      lastBooking: map['lastBooking']?.toString() ?? '',
      status: map['status']?.toString() ?? 'active',
    );
  }
}
