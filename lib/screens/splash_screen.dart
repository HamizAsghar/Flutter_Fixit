import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import '../screens/provider/provider_main_screen.dart';
import '../utils/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'dart:developer' as dev;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authController = Get.find<AuthController>();
      final session = Supabase.instance.client.auth.currentSession;

      dev.log(
        '🔍 Checking session: ${session != null ? "Found" : "Not found"}',
        name: 'SplashScreen',
      );

      if (session != null) {
        // User is logged in, wait for user data to load
        dev.log('✅ Session found, loading user data', name: 'SplashScreen');

        // Wait a bit for auth controller to load user data
        await Future.delayed(const Duration(milliseconds: 500));

        if (authController.currentUser.value != null) {
          final user = authController.currentUser.value!;
          dev.log(
            '✅ User data loaded: ${user.name} (${user.role})',
            name: 'SplashScreen',
          );

          // Navigate based on role
          if (user.isProvider) {
            Get.offAll(() => const ProviderMainScreen());
          } else {
            Get.offAll(() => const HomeScreen());
          }
        } else {
          // Session exists but user data not loaded yet, go to onboarding
          dev.log(
            '⚠️ Session exists but user data not loaded',
            name: 'SplashScreen',
          );
          Get.offAll(() => const OnboardingScreen());
        }
      } else {
        // No session, go to onboarding
        dev.log(
          'ℹ️ No session found, showing onboarding',
          name: 'SplashScreen',
        );
        Get.offAll(() => const OnboardingScreen());
      }
    } catch (e) {
      dev.log('❌ Error checking auth: $e', name: 'SplashScreen');
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.background],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            Center(
              child: Image.asset('assets/images/mainlogo.png', width: 200)
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(
                    duration: 800.ms,
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.easeOutBack,
                  ),
            ),
            const SizedBox(height: 24),
            // Text Animation
            Text(
                  "On-Demand Home Services",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                )
                .animate(delay: 400.ms)
                .fade(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

            const SizedBox(height: 60),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ).animate(delay: 800.ms).fade(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
