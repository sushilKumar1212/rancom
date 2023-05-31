import 'package:flutter/material.dart';

extension AppColors on Color {
  static const Color primary = Color(0xFFEBAA35);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFE5E5E5);
  static const Color darkGrey = Color(0xFFAFAFAF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF43A047);
  static const Color blue = Color(0xFF1E88E5);
  static const Color yellow = Color(0xFFFFC107);
  static const Color transparent = Color(0x00000000);

  static Color fromHex(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
