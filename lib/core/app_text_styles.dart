import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle titleBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading = GoogleFonts.notoSans(
    color: AppColors.secondary,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading40 = GoogleFonts.notoSans(
    color: AppColors.darkText,
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading15 = GoogleFonts.notoSans(
    color: AppColors.darkText,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.notoSans(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyBold = GoogleFonts.notoSans(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodylighttextSecondary = GoogleFonts.notoSans(
    color: AppColors.primary,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle bodybuttonBackground = GoogleFonts.notoSans(
    color: AppColors.buttonBackground,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodywarning = GoogleFonts.notoSans(
    color: AppColors.warning,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body20 = GoogleFonts.notoSans(
    color: AppColors.textSecondary,
    fontSize: 40,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle bodyLighttextSecondary20 = GoogleFonts.notoSans(
    color: AppColors.secondary,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyWhite20 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle body11 = GoogleFonts.notoSans(
    color: AppColors.textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
}
