import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:fixit/controllers/auth_controller.dart';
import 'package:fixit/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();

  bool _obscurePassword = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              /// LOGO
              Center(
                child: Image.asset('assets/images/mainlogo.png', height: 120)
                    .animate()
                    .fade(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ),

              const SizedBox(height: 40),

              /// TITLE
              Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ).animate().fade(delay: 200.ms).slideX(begin: -0.1, end: 0),

              const SizedBox(height: 8),

              Text(
                "Login to continue using Fixit services.",
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fade(delay: 300.ms).slideX(begin: -0.1, end: 0),

              const SizedBox(height: 48),

              /// EMAIL
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
              ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 16),

              /// PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ).animate().fade(delay: 500.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 12),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// LOGIN BUTTON
              Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : _handleLogin,
                        child: _authController.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Sign In"),
                      ),
                    ),
                  )
                  .animate()
                  .fade(delay: 600.ms)
                  .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 32),

              /// DIVIDER
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Or login with",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 32),

              /// SOCIAL BUTTONS (NO LOGIC YET)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _handleGoogleLogin,
                      child: _socialButton(
                        icon: FontAwesomeIcons.google,
                        label: "Google",
                        color: Colors.red[50],
                        iconColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _socialButton(
                      icon: FontAwesomeIcons.apple,
                      label: "Apple",
                      color: Colors.grey[100],
                      iconColor: Colors.black,
                    ),
                  ),
                ],
              ).animate(delay: 700.ms).fade().slideY(begin: 0.1, end: 0),

              const SizedBox(height: 40),

              /// REGISTER LINK
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= LOGIN LOGIC =================
  Future<void> _handleGoogleLogin() async {
    await _authController.signInWithGoogle();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        '⚠️ Missing Information',
        'Please enter email and password',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  /// ================= SOCIAL BUTTON =================
  Widget _socialButton({
    required IconData icon,
    required String label,
    Color? color,
    Color? iconColor,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
