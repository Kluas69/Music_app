import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final Function(int) onTabChange;

  const BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    // Determine the selected index based on the current route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    int selectedIndex = 0;
    if (currentRoute == '/library') {
      selectedIndex = 1;
    } else if (currentRoute == '/profile') {
      selectedIndex = 2;
    } else {
      selectedIndex = 0; // Default to Home for all other routes
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: const Color(0xFF1DB954).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: GNav(
        backgroundColor: Colors.transparent,
        color: Colors.grey[600],
        activeColor: Colors.white,
        tabBackgroundColor: Colors.transparent,
        tabBackgroundGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1DB954), Color(0xFF0D9044)],
        ),
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: const Duration(milliseconds: 300),
        tabBorderRadius: 20,
        haptic: true,
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            iconSize: 24,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GButton(
            icon: Icons.library_music,
            text: 'Library',
            iconSize: 24,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
            iconSize: 24,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
