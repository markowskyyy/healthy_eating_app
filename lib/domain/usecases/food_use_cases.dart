import 'package:healthy_eating_app/core/usecase/usecase.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class FoodUseCases {
  final GetFoodEntries getFoodEntries;
  final AddFoodEntry addFoodEntry;
  final UpdateFoodEntry updateFoodEntry;
  final DeleteFoodEntry deleteFoodEntry;

  FoodUseCases({
    required this.getFoodEntries,
    required this.addFoodEntry,
    required this.updateFoodEntry,
    required this.deleteFoodEntry,
  });

  factory FoodUseCases.fromRepository(FoodRepository repository) {
    return FoodUseCases(
      getFoodEntries: GetFoodEntries(repository),
      addFoodEntry: AddFoodEntry(repository),
      updateFoodEntry: UpdateFoodEntry(repository),
      deleteFoodEntry: DeleteFoodEntry(repository),
    );
  }
}

class DeleteFoodEntry implements UseCase<void, String> {
  final FoodRepository _repository;

  DeleteFoodEntry(this._repository);

  @override
  Future<void> call({required String params}) {
    return _repository.deleteEntry(params);
  }
}

class AddFoodEntry implements UseCase<void, FoodEntry> {
  final FoodRepository _repository;

  AddFoodEntry(this._repository);

  @override
  Future<void> call({required FoodEntry params}) {
    return _repository.addEntry(params);
  }
}

class GetFoodEntries implements UseCase<List<FoodEntry>, void>{
  final FoodRepository _repository;

  GetFoodEntries(this._repository);

  @override
  Future<List<FoodEntry>> call({void params}) {
    return _repository.getEntries();
  }
}


class UpdateFoodEntry implements UseCase<void, FoodEntry> {
  final FoodRepository _repository;

  UpdateFoodEntry(this._repository);

  @override
  Future<void> call({required FoodEntry params}) {
    return _repository.updateEntry(params);
  }
}