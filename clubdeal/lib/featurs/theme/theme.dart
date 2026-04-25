import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const greenDeep = Color(0xFF1B4D3E);
  static const greenMid = Color(0xFF2A6652);
  static const greenLight = Color(0xFF3D8B6E);
  static const cream = Color(0xFFF5EDCB);
  static const creamDark = Color(0xFFE8D9A8);
  static const charcoal = Color(0xFF0F2920);
  static const charcoalMid = Color(0xFF173523);
  static const textMuted = Color(0x80F5EDCB);
  static const border = Color(0x1AF5EDCB);

  // status colors
  static const success = Color(0xFF4CAF82);
  static const warning = Color(0xFFE8A838);
  static const error = Color(0xFFE05555);
  static const info = Color(0xFF5B9BD5);

  ///
  static const scaffoldBg = Color(0xFF0B1F17);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    colorScheme: ColorScheme.dark(
      primary: AppColors.greenMid,
      secondary: AppColors.cream,
      surface: AppColors.charcoalMid,
      background: AppColors.charcoal,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.cream, displayColor: AppColors.cream),
    cardTheme: CardThemeData(
      color: AppColors.charcoalMid,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
    ),
  );
}
