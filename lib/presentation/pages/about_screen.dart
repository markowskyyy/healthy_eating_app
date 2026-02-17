import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/presentation/widgets/bullet_point.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'О приложении',
            style: AppTextStyles.title.copyWith(color: Colors.white)
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.restaurant_menu,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Healthy Eating App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Версия 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Это приложение помогает отслеживать ваш ежедневный рацион и получать персонализированные рекомендации по питанию от искусственного интеллекта.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Возможности:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: 'Добавление продуктов с указанием калорий'),
            BulletPoint(text: 'Просмотр записей за любой день'),
            BulletPoint(text: 'Удаление записей'),
            BulletPoint(text: 'Анализ рациона с помощью DeepSeek AI'),
          ],
        ),
      ),
    );
  }
}
