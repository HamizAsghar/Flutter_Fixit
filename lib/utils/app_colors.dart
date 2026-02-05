import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors from logo
  static const Color primary = Color(0xFF1D3557);    // Deep dark blue
  static const Color secondary = Color(0xFF457B9D);  // Medium blue
  static const Color primaryLight = Color(0xFFA8DADC); // Pale aqua

  // Supportive colors
  static const Color accent = Color(0xFFE63946);     // Sophisticated Red (for CTAs)
  static const Color background = Color(0xFFF1F5F9); // Very light slate gray
  static const Color surface = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
