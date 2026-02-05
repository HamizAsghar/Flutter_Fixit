import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final serviceController = Get.find<ServiceController>();
  final authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = "Plumbing";

  final List<String> _categories = [
    "Plumbing",
    "Electrical",
    "Cleaning",
    "Painting",
    "Carpentry",
    "AC Repair",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "List New Service",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 32),
              _buildTextField(
                "Service Title",
                "e.g. Bathroom Sink Leak Fix",
                _titleController,
              ),
              const SizedBox(height: 20),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),
              _buildTextField(
                "Base Price (Rs.)",
                "e.g. 25",
                _priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                "Description",
                "Describe what's included in this service...",
                _descController,
                maxLines: 4,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: serviceController.isLoading.value
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            // Get Category ID
                            final catResponse = await Supabase.instance.client
                                .from('categories')
                                .select('id')
                                .eq('name', _selectedCategory)
                                .single();
                            
                            final categoryId = catResponse['id'];

                            final success = await serviceController.addService({
                              'provider_id': authController.currentUser.value!.id,
                              'category_id': categoryId,
                              'name': _titleController.text.trim(),
                              'description': _descController.text.trim(),
                              'base_price': double.parse(_priceController.text.trim()),
                              'is_active': true,
                            });

                            if (success) {
                              Get.snackbar('Success', 'Service Published Successfully!',
                                  backgroundColor: Colors.green, colorText: Colors.white);
                              Navigator.pop(context);
                            } else {
                              Get.snackbar('Error', 'Failed to publish service',
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          }
                        },
                  child: serviceController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Publish Service"),
                )),
              ).animate().fade().scale(begin: const Offset(0.95, 0.95)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 40,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            "Add Service Photos",
            style: TextStyle(
              color: AppColors.primary.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1, end: 0);
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $label";
            }
            return null;
          },
        ),
      ],
    ).animate().fade().slideX(begin: 0.05, end: 0);
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    ).animate().fade().slideX(begin: 0.05, end: 0);
  }
}
