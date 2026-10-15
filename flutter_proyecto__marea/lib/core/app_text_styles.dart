import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle titleOnDark([double size = 28]) => GoogleFonts.fraunces(
        fontSize: size, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle subtitleOnDark = GoogleFonts.workSans(
      fontSize: 12, color: AppColors.textMutedOnDark);

  static TextStyle label = GoogleFonts.workSans(
      fontSize: 11, color: AppColors.textMuted);

  static TextStyle input = GoogleFonts.workSans(
      fontSize: 13, color: AppColors.textDark);

  static TextStyle button = GoogleFonts.workSans(
      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark);

  static TextStyle small = GoogleFonts.workSans(
      fontSize: 12, color: AppColors.textMuted);

  static TextStyle smallBold = GoogleFonts.workSans(
      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark);
}