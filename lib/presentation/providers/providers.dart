import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';
import 'package:healthy_eating_app/core/analytics/appmetrica_analytics_service.dart';
import 'package:healthy_eating_app/core/analytics/firebase_screen_analytics.dart';
import 'package:healthy_eating_app/data/repositories/firebase_food_repository.dart';
import 'package:healthy_eating_app/data/repositories/openrouter_ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';
import 'package:healthy_eating_app/domain/usecases/food_use_cases.dart';
import 'package:healthy_eating_app/domain/usecases/get_recommendations.dart';


// Репозитории
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final analytics = ref.watch(analyticsServiceProvider);
  final firestore = FirebaseFirestore.instance;
  const userId = '24YaHokBbjhecgiRvyahKn4l8c73';
  // TODO(markovskyyy): при расширении сделать singleTon с подписокой на uid status юзера от FireBase

  return FirebaseFoodRepository(
      firestore: firestore,
      userId: userId,
      analytics: analytics
  );
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final apiKey = dotenv.env['OPENROUTER_API_KEY']!;
  final model = dotenv.env['DEEPSEEK_MODEL']!;
  return OpenRouterAiRepository(apiKey: apiKey, model: model);
});

// Use cases
final foodUseCasesProvider = Provider<FoodUseCases>((ref) {
  final repo = ref.watch(foodRepositoryProvider);
  return FoodUseCases.fromRepository(repo);
});

final getRecommendationsProvider = Provider<GetRecommendations>((ref) {
  final foodRepo = ref.watch(foodRepositoryProvider);
  final aiRepo = ref.watch(aiRepositoryProvider);
  return GetRecommendations(foodRepo, aiRepo);
});





//Аналитика
final analyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});
final screenAnalyticsProvider = Provider<ScreenAnalytics>((ref) {
  return FirebaseScreenAnalytics(
    FirebaseAnalytics.instance,
  );
});



final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AppMetricaAnalyticsService();
});