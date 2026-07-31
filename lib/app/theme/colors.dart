import 'package:flutter/material.dart';

/// ScoutMe — Premium Football Recruitment Platform
/// Premium orange palette — warm, energetic, professional
class AppColors {
  // ── Brand (Orange) ──
  static const Color primary = Color(0xFFF97316);
  static const Color primaryLight = Color(0xFFFB923C);
  static const Color primaryDark = Color(0xFFEA580C);
  static const Color accent = Color(0xFFFFEDD5);

  // ── Backgrounds ──
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F5F9);

  // ── Text ──
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders & Dividers ──
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color inputFill = Color(0xFFF5F6F8);

  // ── Semantic ──
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF3B82F6);

  // ── Match Tiers ──
  static const Color matchExcellent = Color(0xFFF97316);
  static const Color matchGood = Color(0xFF3B82F6);
  static const Color matchPotential = Color(0xFFF59E0B);
  static const Color matchLow = Color(0xFF9CA3AF);

  // ── Social ──
  static const Color google = Color(0xFFEA4335);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);

  // ── Shadows ──
  static Color shadow = const Color(0xFF000000).withValues(alpha: 0.04);
  static Color shadowMedium = const Color(0xFF000000).withValues(alpha: 0.06);
  static Color shadowHeavy = const Color(0xFF000000).withValues(alpha: 0.10);

  // ── Gradients ──
  static const List<Color> orangeGradient = [
    Color(0xFFF97316),
    Color(0xFFFB923C),
  ];
}
