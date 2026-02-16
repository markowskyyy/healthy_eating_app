import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/food_entry.dart';
import '../../../domain/usecases/food_use_cases.dart';
import '../../providers/providers.dart';

part 'home_viewmodel.freezed.dart';
part 'home_viewmodel.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required DateTime selectedDate,
    required List<FoodEntry> entries,
  }) = _HomeState;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late final FoodUseCases _useCases;

  @override
  Future<HomeState> build() async {
    _useCases = ref.watch(foodUseCasesProvider);
    final now = DateTime.now();
    final allEntries = await _useCases.getFoodEntries(params: null);
    final todaysEntries = _filterEntriesByDate(allEntries, now);
    return HomeState(selectedDate: now, entries: todaysEntries);
  }

  List<FoodEntry> _filterEntriesByDate(List<FoodEntry> entries, DateTime date) {
    return entries.where((e) =>
    e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day).toList();
  }

  Future<void> selectDate(DateTime date) async {
    final allEntries = await _useCases.getFoodEntries(params: null);
    final filtered = _filterEntriesByDate(allEntries, date);
    state = AsyncValue.data(state.value!.copyWith(selectedDate: date, entries: filtered));
  }

  Future<void> addEntry(String name, double? calories) async {
    final entry = FoodEntry(
      id: const Uuid().v4(),
      date: state.value!.selectedDate,
      name: name,
      calories: calories,
    );
    await _useCases.addFoodEntry(params: entry);
    // После добавления обновляем список
    final allEntries = await _useCases.getFoodEntries(params: null);
    final filtered = _filterEntriesByDate(allEntries, state.value!.selectedDate);
    state = AsyncValue.data(state.value!.copyWith(entries: filtered));
  }

  Future<void> updateEntry(FoodEntry entry) async {
    await _useCases.updateFoodEntry(params: entry);
    final allEntries = await _useCases.getFoodEntries(params: null);
    final filtered = _filterEntriesByDate(allEntries, state.value!.selectedDate);
    state = AsyncValue.data(state.value!.copyWith(entries: filtered));
  }

  Future<void> deleteEntry(String id) async {
    await _useCases.deleteFoodEntry(params: id);
    final allEntries = await _useCases.getFoodEntries(params: null);
    final filtered = _filterEntriesByDate(allEntries, state.value!.selectedDate);
    state = AsyncValue.data(state.value!.copyWith(entries: filtered));
  }
}