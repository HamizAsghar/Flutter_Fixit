import 'package:fixit/controllers/auth_controller.dart';
import 'package:fixit/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Text(
              "Forgot Password",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ).animate().fade().slideX(begin: -0.1),

            const SizedBox(height: 12),

            Text(
              "Enter your email address and we'll send you a link to reset your password.",
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fade(delay: 100.ms),

            const SizedBox(height: 40),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email Address",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ).animate().fade(delay: 200.ms).slideY(begin: 0.1),

            const SizedBox(height: 32),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _authController.isLoading.value
                      ? null
                      : _handleResetPassword,
                  child: _authController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Send Reset Link"),
                ),
              ),
            ).animate().fade(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar(
        '⚠️ Missing Information',
        'Please enter your email address',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _authController.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (success) {
      Get.back();
    }
  }
}
