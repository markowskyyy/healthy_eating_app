import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/usecases/food_use_cases.dart';
import 'package:healthy_eating_app/presentation/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    return HomeState(selectedDate: now, entries: allEntries);
  }

  List<FoodEntry> _filterEntriesByDate(List<FoodEntry> entries, DateTime date) {
    return entries.where((e) =>
    e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day).toList();
  }

  Future<void> selectDate(DateTime date) async {
    final today = DateTime.now();
    if (date.isAfter(today)) return;
    state = AsyncValue.data(state.value!.copyWith(selectedDate: date));
  }

  List<FoodEntry> filteredEntries () {
    return _filterEntriesByDate(state.value!.entries, state.value!.selectedDate);
  }

  Future<void> addEntry(String name, double mass, double? calories) async {
    final entryID = DateTime.now().millisecondsSinceEpoch.toString();
    final entry = FoodEntry(
      id: entryID,
      date: state.value!.selectedDate,
      name: name,
      mass: mass,
      calories: calories,
    );

    await _useCases.addFoodEntry(params: entry);
    final allEntries = await _useCases.getFoodEntries(params: null);
    state = AsyncValue.data(state.value!.copyWith(entries: allEntries));
  }

  Future<void> updateEntry(FoodEntry entry) async {
    await _useCases.updateFoodEntry(params: entry);
    final updatedEntries = state.value!.entries.map((e) {
      return e.id == entry.id ? entry : e;
    }).toList();
    state = AsyncValue.data(state.value!.copyWith(entries: updatedEntries));
  }

  Future<void> deleteEntry(String id) async {
    await _useCases.deleteFoodEntry(params: id);
    final allEntries = await _useCases.getFoodEntries(params: null);
    state = AsyncValue.data(state.value!.copyWith(entries: allEntries));
  }
}