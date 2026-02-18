import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthy_eating_app/data/repositories/firebase_food_repository.dart';
import 'package:healthy_eating_app/data/repositories/openrouter_ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';
import 'package:healthy_eating_app/domain/usecases/food_use_cases.dart';
import 'package:healthy_eating_app/domain/usecases/get_recommendations.dart';


// Репозитории
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  const userId = '24YaHokBbjhecgiRvyahKn4l8c73';
  // TODO(markovskyyy): при расширении сделать singleTon с подписокой на uid status юзера от FireBase

  return FirebaseFoodRepository(firestore: firestore, userId: userId);
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