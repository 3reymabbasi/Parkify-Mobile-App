import 'package:flutter/material.dart';

import '../bookings/my_bookings_view.dart';
import '../reports/report_view.dart';
import '../profile/profile_view.dart';
import 'home_content_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeContentView(),
    MyBookingsView(),
    ReportView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          _buildNavDestination(
            Icons.location_on_outlined,
            Icons.location_on,
            'Home',
            0,
          ),
          _buildNavDestination(
            Icons.calendar_today_outlined,
            Icons.calendar_today,
            'Bookings',
            1,
          ),
          _buildNavDestination(
            Icons.description_outlined,
            Icons.description,
            'Reports',
            2,
          ),
          _buildNavDestination(
            Icons.person_outline,
            Icons.person,
            'Profile',
            3,
          ),
        ],
      ),
    );
  }

  NavigationDestination _buildNavDestination(
    IconData icon,
    IconData selectedIcon,
    String label,
    int index,
  ) {
    final bool isSelected = _currentIndex == index;
    const selectedColor = Color(0xFF00796B);

    return NavigationDestination(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selectedColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? selectedColor : Colors.grey.shade600,
            size: 28,
          ),
        ],
      ),
      label: label,
    );
  }
}
