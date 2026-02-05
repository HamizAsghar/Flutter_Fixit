import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_colors.dart';
import '../models/category_model.dart';
import 'category_detail_screen.dart';

class ProblemDetectionScreen extends StatefulWidget {
  const ProblemDetectionScreen({super.key});

  @override
  State<ProblemDetectionScreen> createState() => _ProblemDetectionScreenState();
}

class _ProblemDetectionScreenState extends State<ProblemDetectionScreen> {
  File? _selectedImage;
  bool _isAnalyzing = false;
  CategoryModel? _detectedCategory;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _isAnalyzing = true;
        _detectedCategory = null;
      });

      // Simulate AI analysis delay
      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          // Randomly pick a category from mock data to simulate AI result
          final random = Random();
          _detectedCategory =
              mockCategories[random.nextInt(mockCategories.length)];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "AI Problem Finder",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInstructions(),
            const SizedBox(height: 32),
            Expanded(
              child: _selectedImage == null
                  ? _buildUploadPlaceholder()
                  : _buildImagePreview(),
            ),
            const SizedBox(height: 32),
            if (_detectedCategory != null) _buildResultCard(),
            const SizedBox(height: 32),
            if (!_isAnalyzing) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Snap a photo of the issue. Our AI will analyze it and suggest the best professional for the job.",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: -0.1, end: 0);
  }

  Widget _buildUploadPlaceholder() {
    return GestureDetector(
      onTap: () => _showPickerOptions(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Start AI Analysis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Take a photo or upload from gallery",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (_isAnalyzing) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          // Scanning Line Animation
          Positioned.fill(
            child: Column(
              children: [
                Container(
                      height: 3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryLight.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .moveY(
                      begin: 0,
                      end: 400,
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpinKitPulse(color: Colors.white, size: 100),
                const SizedBox(height: 24),
                const Text(
                      "AI is Analyzing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2.seconds,
                      color: AppColors.primaryLight,
                    ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _detectedCategory!.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _detectedCategory!.color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _detectedCategory!.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _detectedCategory!.icon,
              color: _detectedCategory!.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "AI Recommendation",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _detectedCategory!.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CategoryDetailScreen(category: _detectedCategory!),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 44),
              backgroundColor: _detectedCategory!.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "View Services",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () => setState(() {
              _selectedImage = null;
              _detectedCategory = null;
            }),
            icon: const Icon(Icons.refresh),
            label: const Text("Reset"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              minimumSize: const Size(0, 56),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _showPickerOptions(),
            icon: const Icon(Icons.upload_file),
            label: const Text("New Analysis"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    ).animate().fade(delay: 200.ms);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Source",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _pickerItem(Icons.camera_enhance, "Camera", () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                }),
                _pickerItem(Icons.photo_library, "Gallery", () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _pickerItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
