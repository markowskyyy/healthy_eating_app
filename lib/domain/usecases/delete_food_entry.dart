import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class DeleteFoodEntry {
  final FoodRepository repository;

  DeleteFoodEntry(this.repository);

  Future<void> call(String id) {
    return repository.deleteEntry(id);
  }
}