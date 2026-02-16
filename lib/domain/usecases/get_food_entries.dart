import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class GetFoodEntries {
  final FoodRepository repository;

  GetFoodEntries(this.repository);

  Future<List<FoodEntry>> call(DateTime date) {
    return repository.getEntriesForDate(date);
  }
}