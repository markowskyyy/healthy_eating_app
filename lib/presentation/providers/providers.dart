import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthy_eating_app/core/analytics/analytics_hub.dart';
import 'package:healthy_eating_app/core/analytics/appsflyer_analytics_service.dart';
import 'package:healthy_eating_app/data/repositories/apphud_repository_impl.dart';
import 'package:healthy_eating_app/core/analytics/appmetrica_analytics_service.dart';
import 'package:healthy_eating_app/core/analytics/firebase_analytics_service.dart';
import 'package:healthy_eating_app/data/repositories/firebase_food_repository.dart';
import 'package:healthy_eating_app/data/repositories/openrouter_ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/apphud_repository.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';
import 'package:healthy_eating_app/domain/usecases/food_use_cases.dart';
import 'package:healthy_eating_app/domain/usecases/get_recommendations.dart';


// Репозитории
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final analytics = ref.watch(analyticsHubProvider);
  final firestore = FirebaseFirestore.instance;
  const userId = '24YaHokBbjhecgiRvyahKn4l8c73';

  return FirebaseFoodRepository(
      firestore: firestore, userId: userId, analytics: analytics
  );
}); // TODO(markovskyyy): при расширении сделать singleTon с подписокой на uid status юзера от FireBase

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final analytics = ref.watch(analyticsHubProvider);
  final apiKey = dotenv.env['OPENROUTER_API_KEY']!;
  final model = dotenv.env['DEEPSEEK_MODEL']!;
  return OpenRouterAiRepository(apiKey: apiKey, model: model, analytics: analytics);
});

// AppHud
final appHudRepositoryProvider = Provider<AppHudRepository>((ref) {
  final appsFlyer = ref.read(appsFlyerSdkProvider);
  return AppHudRepositoryIml(appsFlyer: appsFlyer);
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

// Проверка ATT
final canTrackProvider = Provider<bool>((ref) {
  throw UnimplementedError();
});

// SDK apps flyer
final appsFlyerSdkProvider = Provider<AppsflyerSdk>((ref) {
  throw UnimplementedError('appsFlyerSdkProvider must be overridden in main');
});

// провайдер для обращение ко все инструментам аналитики
final analyticsHubProvider = Provider<AnalyticsHub>((ref) {
  final appsflyer = ref.watch(appsFlyerSdkProvider);
  final canTrack = ref.watch(canTrackProvider);
  final firebase  = FirebaseAnalytics.instance;

  return AnalyticsHub([
    FirebaseAnalyticsService(
        canTrack: canTrack,
        analytics: firebase
    ),
    AppsFlyerAnalyticsService(
      canTrack: canTrack,
      appsflyerSdk: appsflyer,
    ),
    AppMetricaAnalyticsService(
      canTrack: canTrack,
    ),
  ]);
});