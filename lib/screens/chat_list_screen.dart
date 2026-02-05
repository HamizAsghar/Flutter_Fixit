import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Messages",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _chatTile(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _chatTile(BuildContext context, int index) {
    final names = [
      "Ahmed Khan",
      "Saira Ali",
      "Zaid Sheikh",
      "Maria Doe",
      "John Smith",
    ];
    final services = [
      "Plumbing",
      "Cleaning",
      "Electrician",
      "Painting",
      "Gardening",
    ];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          'https://i.pravatar.cc/150?u=${names[index]}',
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            names[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "12:30 PM",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Hey! I'll be there by 2 PM for the ${services[index]} job.",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            if (index == 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  "1",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      onTap: () {},
    ).animate().fade().slideY(begin: 0.1, end: 0);
  }
}
