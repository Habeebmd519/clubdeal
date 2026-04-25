import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── AppColors ──────────────────────────────────────────────────────────────────
// Deep forest-noir theme: near-black greens, aged gold accents, warm cream text.
// Every existing name is preserved — only values and additions changed.
class AppColors {
  // ── Green Ramp ─────────────────────────────────────────────────────────────
  // Rich jewel-tone greens with better contrast between each step
  static const greenDeep = Color(0xFF0E3528); // darkest — large surfaces
  static const greenMid = Color(0xFF1A5C40); // mid — cards, containers
  static const greenLight = Color(0xFF2E8C60); // accent — active elements
  static const greenGlow = Color(0xFF3FAD76); // brightest — highlights, CTAs
  static const greenSubtle = Color(
    0xFF163B2C,
  ); // between deep & mid — hover states

  // ── Cream Ramp ─────────────────────────────────────────────────────────────
  // Warm parchment tones — reads beautifully on dark green
  static const cream = Color(0xFFF4E8C1); // primary text
  static const creamDark = Color(0xFFD9C98A); // secondary text, subheadings
  static const creamDim = Color(0xFF8A7D5A); // placeholder, muted text
  static const creamFaint = Color(0xFF4A4232); // very subtle tint, disabled

  // ── Charcoal / Background Ramp ─────────────────────────────────────────────
  // Near-black greens — deeper and more saturated than before
  static const charcoal = Color(0xFF091A11); // deepest bg (behind scaffold)
  static const charcoalMid = Color(0xFF0F2318); // scaffold bg
  static const charcoalHi = Color(0xFF152D1F); // elevated surface (cards)
  static const charcoalTop = Color(
    0xFF1C3829,
  ); // highest surface (modals, sheets)

  // ── Gold Accent ────────────────────────────────────────────────────────────
  // Warm gold to complement forest greens — replaces plain orange/amber
  static const gold = Color(0xFFD4A843); // primary accent (badges, highlights)
  static const goldDim = Color(0xFF8C6C24); // muted gold (borders, icons)
  static const goldFaint = Color(0xFF3D2E0E); // very subtle gold bg tint

  // ── Semantic — Status ──────────────────────────────────────────────────────
  // Tuned to sit well on dark green backgrounds
  static const success = Color(0xFF41C47A); // confirmed, delivered
  static const successDim = Color(0xFF133D26); // success bg tint
  static const warning = Color(0xFFE0A030); // pending, preparing
  static const warningDim = Color(0xFF3D2800); // warning bg tint
  static const error = Color(0xFFD94F4F); // cancelled, failed
  static const errorDim = Color(0xFF3D1212); // error bg tint
  static const info = Color(0xFF4A90D9); // info / neutral
  static const infoDim = Color(0xFF0F2540); // info bg tint

  // ── Semantic — Surfaces ────────────────────────────────────────────────────
  static const scaffoldBg = charcoal; // root Scaffold background
  static const cardBg = charcoalHi; // standard card / container
  static const inputBg = charcoalMid; // TextField, search bar bg
  static const sheetBg = charcoalTop; // BottomSheet, Dialog bg
  static const overlayBg = Color(0xCC091A11); // modal scrim (80% charcoal)

  // ── Semantic — Borders ─────────────────────────────────────────────────────
  static const border = Color(
    0x1AF4E8C1,
  ); // subtle — default dividers (10% cream)
  static const borderMid = Color(
    0x33F4E8C1,
  ); // medium — hover / focus (20% cream)
  static const borderHi = Color(
    0x55F4E8C1,
  ); // strong — selected / active (33% cream)
  static const divider = Color(
    0x0DF4E8C1,
  ); // hairline — list separators (5% cream)

  // ── Semantic — Text ────────────────────────────────────────────────────────
  static const textPrimary = cream; // headings, body
  static const textSecondary = creamDark; // subtext, labels
  static const textMuted = creamDim; // placeholders, hints
  static const textDisabled = creamFaint; // disabled state

  // ── Semantic — Interactive ─────────────────────────────────────────────────
  static const accent = greenGlow; // primary buttons, links
  static const accentDim = greenMid; // secondary buttons, chips
  static const highlight = gold; // badges, price text, live indicators
  static const highlightDim = goldDim; // muted highlights, icons
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
