import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';

class ProviderOrdersScreen extends StatelessWidget {
  const ProviderOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Manage Orders",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "New Requests"),
              Tab(text: "Active Jobs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildNewRequestsList(), _buildActiveJobsList()],
        ),
      ),
    );
  }

  Widget _buildNewRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _orderCard(
          context,
          service: "Tap Leak Repair",
          customer: "Dwight Schrute",
          address: "Schrute Farms, PA",
          price: "Rs. 30",
          time: "Today, 5:00 PM",
          isNew: true,
        ).animate().fade(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildActiveJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 1,
      itemBuilder: (context, index) {
        return _orderCard(
          context,
          service: "AC Installation",
          customer: "Angela Martin",
          address: "Accounting Dept, PA",
          price: "Rs. 150",
          time: "Tomorrow, 10:00 AM",
          isNew: false,
        ).animate().fade().scale(begin: const Offset(0.95, 0.95));
      },
    );
  }

  Widget _orderCard(
    BuildContext context, {
    required String service,
    required String customer,
    required String address,
    required String price,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.person_outline, customer),
          const SizedBox(height: 6),
          _infoRow(Icons.location_on_outlined, address),
          const SizedBox(height: 6),
          _infoRow(Icons.access_time, time),
          const SizedBox(height: 24),
          if (isNew)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Decline"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Order Accepted! Moving to Active Jobs.",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Accept"),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Complete Job"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
