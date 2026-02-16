import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class AddFoodEntry {
  final FoodRepository repository;

  AddFoodEntry(this.repository);

  Future<void> call(FoodEntry entry) {
    return repository.addEntry(entry);
  }
}