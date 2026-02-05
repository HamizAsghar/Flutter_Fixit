import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'dart:developer' as dev;

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser.value;
    _nameController = TextEditingController(text: user?.name ?? "");
    _emailController = TextEditingController(text: user?.email ?? "");
    _phoneController = TextEditingController(text: user?.phone ?? "");
    _addressController = TextEditingController(text: user?.address ?? "");
    _cityController = TextEditingController(text: user?.city ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = authController.currentUser.value;
      if (user == null) throw Exception('User not found');

      dev.log('💾 Updating user profile', name: 'AccountInfo');

      // Update in Supabase
      await Supabase.instance.client
          .from('users')
          .update({
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'city': _cityController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      // Reload user data
      await authController.reloadUserData();

      dev.log('✅ Profile updated successfully', name: 'AccountInfo');

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });

        Get.snackbar(
          '✅ Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      dev.log('❌ Error updating profile: $e', name: 'AccountInfo');

      if (mounted) {
        setState(() => _isSaving = false);

        Get.snackbar(
          '❌ Error',
          'Failed to update profile: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Account Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isSaving)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: AppColors.primary,
              ),
              onPressed: () {
                if (_isEditing) {
                  // Cancel editing - reset values
                  final user = authController.currentUser.value;
                  _nameController.text = user?.name ?? "";
                  _phoneController.text = user?.phone ?? "";
                  _addressController.text = user?.address ?? "";
                  _cityController.text = user?.city ?? "";
                }
                setState(() => _isEditing = !_isEditing);
              },
            ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: NetworkImage(
                          user.avatarUrl ??
                              'https://api.dicebear.com/7.x/lorelei/png?seed=${user.email}',
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 18,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ).animate().scale(duration: 400.ms),
                const SizedBox(height: 40),
                _infoField(
                  "Full Name",
                  _nameController,
                  Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                _infoField(
                  "Email Address",
                  _emailController,
                  Icons.email_outlined,
                  enabled: false, // Email cannot be changed
                ),
                _infoField(
                  "Phone Number",
                  _phoneController,
                  Icons.phone_android_outlined,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
                _infoField(
                  "City",
                  _cityController,
                  Icons.location_city_outlined,
                ),
                _infoField(
                  "Home Address",
                  _addressController,
                  Icons.location_on_outlined,
                  maxLines: 2,
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text("Save Changes"),
                    ),
                  ).animate().fade().slideY(begin: 0.2, end: 0),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    bool enabled = true,
    int maxLines = 1,
  }) {
    final canEdit = _isEditing && enabled;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: canEdit,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
              filled: true,
              fillColor: canEdit ? AppColors.background : Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: canEdit
                    ? const BorderSide(color: AppColors.primaryLight)
                    : BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 100.ms).slideX(begin: 0.05, end: 0);
  }
}
