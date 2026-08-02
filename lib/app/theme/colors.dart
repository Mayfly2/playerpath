import 'package:flutter/material.dart';

/// PlayerPath — Grassroots Football Recruitment Platform
/// Vibrant sunset palette — energetic, warm, fresh
class AppColors {
  // ── Brand (Vibrant Coral-Orange) ──
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C52);
  static const Color primaryDark = Color(0xFFE05520);
  static const Color accent = Color(0xFFFFF4ED);

  // ── Backgrounds (Warm & Light) ──
  static const Color background = Color(0xFFFFFBEB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFFF7F0);

  // ── Text ──
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5A5A7A);
  static const Color textTertiary = Color(0xFF8E8EA0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Borders & Dividers ──
  static const Color border = Color(0xFFF0E8E0);
  static const Color divider = Color(0xFFF5F0EB);
  static const Color inputFill = Color(0xFFFDF6F0);

  // ── Semantic ──
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Match Tiers ──
  static const Color matchExcellent = Color(0xFFFF6B35);
  static const Color matchGood = Color(0xFF3B82F6);
  static const Color matchPotential = Color(0xFFF59E0B);
  static const Color matchLow = Color(0xFF8E8EA0);

  // ── Social ──
  static const Color google = Color(0xFFEA4335);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);

  // ── Dark Backgrounds ──
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceAlt = Color(0xFF1A2332);

  // ── Dark Text ──
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // ── Dark Borders & Dividers ──
  static const Color darkBorder = Color(0xFF2A3A52);
  static const Color darkDivider = Color(0xFF25324A);
  static const Color darkInputFill = Color(0xFF263348);

  // ── Shadows ──
  static Color shadow = const Color(0xFF000000).withValues(alpha: 0.04);
  static Color shadowMedium = const Color(0xFF000000).withValues(alpha: 0.06);
  static Color shadowHeavy = const Color(0xFF000000).withValues(alpha: 0.10);

  // ── Gradients ──
  static const List<Color> orangeGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFF8C52),
  ];
  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFF8C52),
    Color(0xFFFFB088),
  ];
  static const List<Color> greenAccent = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];
}
