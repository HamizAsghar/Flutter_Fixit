import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/booking_controller.dart';

class ProviderDashboardScreen extends StatelessWidget {
  ProviderDashboardScreen({super.key});

  final authController = Get.find<AuthController>();
  final bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildStatsGrid(),
              const SizedBox(height: 32),
              _buildEarningsCard(),
              const SizedBox(height: 32),
              _buildRecentActivityHeader(),
              const SizedBox(height: 16),
              _buildActivityList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome back,",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Obx(() => Text(
          "${authController.currentUser.value?.name ?? 'Provider'} 👋",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        )),
      ],
    ).animate().fade().slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      final bookings = bookingController.providerBookings;
      final totalJobs = bookings.length;
      final pendingJobs = bookings.where((b) => b.status == 'pending').length;
      final canceledJobs = bookings.where((b) => b.status == 'cancelled').length;

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _statCard(
            "Total Jobs",
            totalJobs.toString(),
            Icons.work_history_outlined,
            Colors.blue,
          ),
          _statCard("Rating", "5.0", Icons.star_outline, Colors.orange),
          _statCard(
            "Pending",
            pendingJobs.toString(),
            Icons.pending_actions_outlined,
            Colors.purple,
          ),
          _statCard(
            "Canceled",
            canceledJobs.toString(),
            Icons.cancel_outlined,
            Colors.red,
          ),
        ],
      );
    }).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Obx(() {
      final completedBookings = bookingController.providerBookings
          .where((b) => b.status == 'completed');
      double totalEarnings = 0;
      for (var b in completedBookings) {
        totalEarnings += b.totalPrice;
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Earnings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Rs. ${totalEarnings.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _earningInfo("Jobs Completed", completedBookings.length.toString()),
                _earningInfo("Status", "Active"),
              ],
            ),
          ],
        ),
      );
    }).animate().fade(delay: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _earningInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Current Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "View All",
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    ).animate().fade(delay: 600.ms);
  }

  Widget _buildActivityList() {
    return Obx(() {
      final recentBookings = bookingController.providerBookings.take(5).toList();

      if (recentBookings.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No current orders"),
          ),
        );
      }

      return Column(
        children: recentBookings.map((booking) {
          return _activityItem(
            "Service #${booking.id.substring(0, 5)}",
            booking.address,
            "Rs. ${booking.totalPrice}",
            "${booking.scheduledDate.hour}:${booking.scheduledDate.minute}",
            booking.status == 'completed'
                ? AppColors.success
                : booking.status == 'pending'
                    ? Colors.orange
                    : AppColors.primary,
          );
        }).toList(),
      );
    }).animate().fade(delay: 700.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _activityItem(
    String service,
    String customer,
    String price,
    String time,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  customer,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
