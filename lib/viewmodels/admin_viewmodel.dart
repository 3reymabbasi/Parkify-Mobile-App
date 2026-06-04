import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AdminViewModel extends ChangeNotifier {
  String _selectedTab = 'All';
  String get selectedTab => _selectedTab;

  final List<UserModel> _users = [
    UserModel(
      initials: 'AK',
      name: 'Ahmed Khan',
      email: 'ahmed.khan@email.com',
      phone: '+92 300 1234567',
      joined: '15/01/2026',
      bookings: 45,
      spent: '12,500',
      lastBooking: 'May 2',
      status: 'active',
    ),
    UserModel(
      initials: 'SA',
      name: 'Sarah Ali',
      email: 'sarah.ali@email.com',
      phone: '+92 301 9876543',
      joined: '20/02/2026',
      bookings: 28,
      spent: '7,800',
      lastBooking: 'May 1',
      status: 'active',
    ),
    UserModel(
      initials: 'FN',
      name: 'Fatima Noor',
      email: 'fatima.noor@email.com',
      phone: '+92 345 7654321',
      joined: '05/04/2026',
      bookings: 19,
      spent: '4,200',
      lastBooking: 'April 28',
      status: 'active',
    ),
    UserModel(
      initials: 'IB',
      name: 'Imran Baig',
      email: 'imran.baig@email.com',
      phone: '+92 333 1122334',
      joined: '10/03/2026',
      bookings: 12,
      spent: '3,150',
      lastBooking: 'April 20',
      status: 'suspended',
    ),
    UserModel(
      initials: 'AN',
      name: 'Arsalan Naseer',
      email: 'arsalan.nas@email.com',
      phone: '+92 333 1122334',
      joined: '10/05/2026',
      bookings: 14,
      spent: '3,150',
      lastBooking: 'April 20',
      status: 'active',
    ),
    UserModel(
      initials: 'MF',
      name: 'Mahir Fareed',
      email: 'maahir@email.com',
      phone: '+92 222 1122334',
      joined: '10/06/2026',
      bookings: 18,
      spent: '3,150',
      lastBooking: 'April 20',
      status: 'active',
    ),
  ];

  List<UserModel> get filteredUsers {
    if (_selectedTab == 'All') return _users;
    return _users.where((u) => u.status == _selectedTab.toLowerCase()).toList();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void suspendUser(int globalIndex) {
    _users[globalIndex].status = 'suspended';
    notifyListeners();
  }

  int globalIndexOf(UserModel user) => _users.indexOf(user);
}
