import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../auth/login_screen.dart';
import '../utils/app_colors.dart';
import 'account_info_screen.dart';
import 'booking_history_screen.dart';
import 'payment_methods_screen.dart';
import 'notification_settings_screen.dart';
import 'security_privacy_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.currentUser.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, user.name, user.email, user.avatarUrl),
            const SizedBox(height: 24),
            _buildProfileMenu(context),
            const SizedBox(height: 40),
            _buildLogoutButton(context, authController),
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    String? avatarUrl,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    avatarUrl ??
                        'https://api.dicebear.com/7.x/lorelei/png?seed=$email',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
            ],
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 20),
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _menuItem(
            context,
            Icons.person_outline,
            "Account Information",
            const AccountInfoScreen(),
          ),
          _menuItem(
            context,
            Icons.history,
            "Booking History",
            const BookingHistoryScreen(),
          ),
          _menuItem(
            context,
            Icons.payment_outlined,
            "Payment Methods",
            const PaymentMethodsScreen(),
          ),
          _menuItem(
            context,
            Icons.notifications_none,
            "Notifications",
            const NotificationSettingsScreen(),
          ),
          _menuItem(
            context,
            Icons.security,
            "Security & Privacy",
            const SecurityPrivacyScreen(),
          ),
          _menuItem(
            context,
            Icons.help_outline,
            "Help & Support",
            const HelpSupportScreen(),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget destination,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textTertiary,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    ).animate().fade().slideX(begin: 0.1, end: 0);
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AuthController authController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton.icon(
        onPressed: () async {
          await authController.signOut();
        },
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: const Text("Logout", style: TextStyle(color: AppColors.error)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ).animate().fade(delay: 400.ms);
  }
}
