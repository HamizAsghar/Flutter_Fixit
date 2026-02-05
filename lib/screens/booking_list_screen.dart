import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../models/booking_model.dart';

class BookingListScreen extends StatelessWidget {
  BookingListScreen({super.key});

  final bookingController = Get.find<BookingController>();

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
    return Obx(() {
      final bookings = bookingController.userBookings.where((b) {
        if (isActive) {
          return b.status != 'completed' && b.status != 'cancelled';
        } else {
          return b.status == 'completed' || b.status == 'cancelled';
        }
      }).toList();

      if (bookings.isEmpty) {
        return const Center(child: Text("No bookings found"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _bookingCard(bookings[index]);
        },
      );
    });
  }

  Widget _bookingCard(BookingModel booking) {
    bool isActive = booking.status != 'completed' && booking.status != 'cancelled';
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
                    Text(
                      "Service #${booking.id.substring(0, 5)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${booking.address} • ${booking.scheduledDate.day}/${booking.scheduledDate.month}/${booking.scheduledDate.year}",
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
                  booking.status.toUpperCase(),
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
              Text(
                "Total Pay: Rs. ${booking.totalPrice}",
                style: const TextStyle(fontWeight: FontWeight.bold),
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
