import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../auth/login_screen.dart'; // Add this line
import '../utils/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: 'assets/images/onboarding_1.png',
      title: 'Professional Service Providers',
      description:
          'Connect with verified and skilled experts for all your home maintenance needs.',
    ),
    OnboardingContent(
      image: 'assets/images/onboarding_2.png',
      title: 'Easy Service Booking',
      description:
          'Book a service in just a few clicks. Upload a photo and let our AI suggest the best expert.',
    ),
    OnboardingContent(
      image: 'assets/images/onboarding_3.png',
      title: 'Hygienic & Safe Home',
      description:
          'Our goal is to make your home a cleaner, safer, and healthier place to live peacefully.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(_contents[index].image, height: 300)
                        .animate(key: ValueKey(index))
                        .fade(duration: 500.ms)
                        .scale(duration: 500.ms, begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 40),
                    Text(
                          _contents[index].title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                        .animate(key: ValueKey("title_$index"))
                        .fade(duration: 500.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 20),
                    Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        )
                        .animate(key: ValueKey("desc_$index"))
                        .fade(duration: 500.ms, delay: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              );
            },
          ),

          // Navigation controls
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _contents.length,
                    (index) => Container(
                      height: 10,
                      width: _currentPage == index ? 25 : 10,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _contents.length - 1) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _contents.length - 1
                            ? "Get Started"
                            : "Continue",
                      ),
                    )
                    .animate()
                    .fade(delay: 500.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ),

          // Skip button
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
