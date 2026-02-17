import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/presentation/viewmodels/home/home_viewmodel.dart';
import 'package:healthy_eating_app/presentation/widgets/food_entry_dialog.dart';
import 'package:healthy_eating_app/presentation/widgets/home_page_body.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);
    final filteredEntries = notifier.filteredEntries();

    return Scaffold(
      appBar: AppBar(
        title: Text('Дневник питания', style: AppTextStyles.titleWhite),
        backgroundColor: AppColors.primary,
      ),
      body: homeState.when(
        data: (state) => HomePageBody(
          selectDate: notifier.selectDate,
          deleteEntry: notifier.deleteEntry,
          selectedDate: state.selectedDate,
          entries: filteredEntries,
          onEditEntry: (entry) => _showEditDialog(context, ref, entry),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => FoodEntryDialog(
        onSubmit: (name, mass, calories) {
          ref.read(homeViewModelProvider.notifier).addEntry(name, mass, calories);
        },
        buttonText: 'Добавить',
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, FoodEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => FoodEntryDialog(
        initialName: entry.name,
        initialMass: entry.mass,
        initialCalories: entry.calories,
        onSubmit: (name, mass, calories) {
          final updatedEntry = FoodEntry(
            id: entry.id,
            date: entry.date,
            name: name,
            mass: mass,
            calories: calories,
          );
          ref.read(homeViewModelProvider.notifier).updateEntry(updatedEntry);
        },
        buttonText: 'Сохранить',
      ),
    );
  }
}
