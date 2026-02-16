import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFFFC107);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );
}