import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  static TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5,
      color: AppColors.textPrimary, height: 1.2,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.5,
      color: AppColors.textPrimary, height: 1.2,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.3,
      color: AppColors.textPrimary, height: 1.3,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22, fontWeight: FontWeight.w700,
      color: AppColors.textPrimary, height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.w700,
      color: AppColors.textPrimary, height: 1.3,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 17, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary, height: 1.4,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary, height: 1.4,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary, height: 1.4,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400,
      color: AppColors.textPrimary, height: 1.6,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400,
      color: AppColors.textSecondary, height: 1.6,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w400,
      color: AppColors.textSecondary, height: 1.5,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary, letterSpacing: 0.2,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w500,
      color: AppColors.textSecondary, letterSpacing: 0.1,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: AppColors.textTertiary, letterSpacing: 0.3,
    ),
  );
}
