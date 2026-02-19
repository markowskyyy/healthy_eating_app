import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';
import 'package:healthy_eating_app/l10n/l10n.dart';
import 'package:healthy_eating_app/presentation/widgets/bullet_point.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.localizations.appName,
            style: AppTextStyles.title.copyWith(color: Colors.white)
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              Text(
                context.localizations.appName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.localizations.appVersion,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                context.localizations.aboutDescription,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              Text(
                context.localizations.featuresTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BulletPoint(text: context.localizations.featureAddFood),
              BulletPoint(text: context.localizations.featureViewDays),
              BulletPoint(text: context.localizations.featureDelete),
              BulletPoint(text: context.localizations.featureAiAnalysis),
              const SizedBox(height: 8),
              Text(
                context.localizations.chooseLanguage,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        LocaleController.set(const Locale('ru'));
                      },
                      child: Text(context.localizations.languageRussian)
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        LocaleController.set(const Locale('en'));
                      },
                      child: Text(context.localizations.languageEnglish)
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
