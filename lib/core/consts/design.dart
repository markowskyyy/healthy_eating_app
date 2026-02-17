import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFFFC107);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const String fontFamily = 'Nunito';

  // Заголовки
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle titleWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Основной текст
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  // Кнопки
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonLight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Цифры/статистика
  static const TextStyle statNumber = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
}
