import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Bookings",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Completed"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildBookingList(isActive: true),
                _buildBookingList(isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList({required bool isActive}) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: isActive ? 1 : 3,
      itemBuilder: (context, index) {
        return _bookingCard(isActive: isActive);
      },
    );
  }

  Widget _bookingCard({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://api.dicebear.com/7.x/lorelei/png?seed=worker',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Plumbing Repair",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ahmed Khan • Dec 31, 2025",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.secondary.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? "In Progress" : "Done",
                  style: TextStyle(
                    color: isActive ? AppColors.secondary : AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pay: Rs. 45.00",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (isActive)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(100, 36),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Track", style: TextStyle(fontSize: 12)),
                )
              else
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(100, 36),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Rate", style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1, end: 0);
  }
}
