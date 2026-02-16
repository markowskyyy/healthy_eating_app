import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class UpdateFoodEntry {
  final FoodRepository repository;

  UpdateFoodEntry(this.repository);

  Future<void> call(FoodEntry entry) {
    return repository.updateEntry(entry);
  }
}