import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/food_use_cases.dart';
import '../../domain/usecases/get_recommendations.dart';
import '../../data/repositories/firebase_food_repository.dart';
import '../../data/repositories/openrouter_ai_repository.dart';

// Репозитории
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  const userId = 'test_user_id'; // замените на реальный
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