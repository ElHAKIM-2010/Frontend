// lib/theme.dart
// Pusat gaya (style) aplikasi:
// - AppColors    : warna-warna yang dipakai di seluruh aplikasi.
// - CategoryStyle: pasangan (ikon, warna gradient) tiap kategori artikel.
// - buildAppTheme(): pengaturan tema global Material 3 + tipografi.
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color bg = Color(0xFFF6F6FB);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F1F8);
  static const Color ink = Color(0xFF1B1B2F);
  static const Color inkSoft = Color(0xFF67677D);
  static const Color inkFaint = Color(0xFF9A9AAF);
  static const Color primary = Color(0xFF5B4FD8);
  static const Color primaryDeep = Color(0xFF4034B0);
  static const Color primarySoft = Color(0xFFE9E7FB);
  static const Color accent = Color(0xFFFFB020);
  static const Color danger = Color(0xFFE5484D);
  static const Color line = Color(0xFFE9E9F0);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDeep],
  );

  static BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF1B1B2F).withValues(alpha: 0.05),
    blurRadius: 24,
    offset: const Offset(0, 12),
  );

  static BoxShadow softShadow = BoxShadow(
    color: const Color(0xFF1B1B2F).withValues(alpha: 0.08),
    blurRadius: 16,
    offset: const Offset(0, 6),
  );
}

class CategoryStyle {
  final IconData icon;
  final List<Color> colors;

  const CategoryStyle({required this.icon, required this.colors});
}

CategoryStyle categoryStyle(String category) {
  const fallback = CategoryStyle(
    icon: Icons.article_outlined,
    colors: [Color(0xFF5B4FD8), Color(0xFF4034B0)],
  );
  switch (category.toLowerCase().trim()) {
    case 'teknologi':
      return const CategoryStyle(
        icon: Icons.memory_outlined,
        colors: [Color(0xFF22C7B8), Color(0xFF0E7490)],
      );
    case 'tips':
      return const CategoryStyle(
        icon: Icons.lightbulb_outline,
        colors: [Color(0xFFFFB020), Color(0xFFEA580C)],
      );
    case 'pendidikan':
      return const CategoryStyle(
        icon: Icons.school_outlined,
        colors: [Color(0xFF5B8DEF), Color(0xFF4F46E5)],
      );
    default:
      return fallback;
  }
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primarySoft,
    onPrimaryContainer: AppColors.primaryDeep,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    error: AppColors.danger,
    shadow: Colors.transparent,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    textTheme: _buildTextTheme(),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: TextStyle(color: AppColors.inkSoft.withValues(alpha: 0.6)),
      labelStyle: const TextStyle(color: AppColors.inkSoft),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

TextTheme _buildTextTheme() {
  final base = Typography.material2021(
    platform: defaultTargetPlatform,
  ).black.apply(bodyColor: AppColors.ink);

  return GoogleFonts.plusJakartaSansTextTheme(base.copyWith(
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
      height: 1.05,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      height: 1.2,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1.25,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 19,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 15.5,
      height: 1.7,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 13.5,
      height: 1.5,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
  ));
}