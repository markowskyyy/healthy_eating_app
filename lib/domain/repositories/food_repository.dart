import 'package:healthy_eating_app/domain/entities/food_entry.dart';

abstract class FoodRepository {
  /// Получить записи за конкретный день
  Future<List<FoodEntry>> getEntries();

  /// Получить записи за период (для рекомендаций)
  Future<List<FoodEntry>> getEntriesForPeriod(DateTime start, DateTime end);

  /// Добавить новую запись
  Future<void> addEntry(FoodEntry entry);

  /// Обновить существующую запись
  Future<void> updateEntry(FoodEntry entry);

  /// Удалить запись по id
  Future<void> deleteEntry(String id);
}