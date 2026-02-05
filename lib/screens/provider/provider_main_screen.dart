import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../utils/app_colors.dart';
import 'provider_dashboard_screen.dart';
import 'provider_orders_screen.dart';
import 'provider_services_screen.dart';
import '../profile_screen.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProviderDashboardScreen(),
    const ProviderOrdersScreen(),
    const ProviderServicesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: AppColors.primary.withOpacity(0.1),
            hoverColor: AppColors.primary.withOpacity(0.05),
            gap: 8,
            activeColor: AppColors.primary,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.primary.withOpacity(0.1),
            color: AppColors.textTertiary,
            tabs: const [
              GButton(icon: Icons.dashboard_outlined, text: 'Home'),
              GButton(icon: Icons.assignment_outlined, text: 'Orders'),
              GButton(icon: Icons.build_outlined, text: 'Services'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
