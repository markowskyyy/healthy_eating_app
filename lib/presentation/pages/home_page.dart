import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/presentation/viewmodels/home/home_viewmodel.dart';
import 'package:healthy_eating_app/presentation/widgets/date_selector.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final notifier = ref.watch(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник питания'),
        backgroundColor: AppColors.primary,
      ),
      body: homeState.when(
        data: (state) => HomePageBody(
          selectDate: notifier.selectDate,
          deleteEntry: notifier.deleteEntry,
          selectedDate: state.selectedDate,
          entries: notifier.filteredEntries(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Добавить запись'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название продукта',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(
                labelText: 'Калории (необязательно)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final calories = double.tryParse(caloriesController.text);
                ref.read(homeViewModelProvider.notifier).addEntry(name, 22.0, calories);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

class HomePageBody extends StatelessWidget {
  final Function(String id) deleteEntry;
  final Function(DateTime date) selectDate;
  final DateTime selectedDate;
  final List<FoodEntry> entries;
  const HomePageBody({
    super.key,
    required this.deleteEntry,
    required this.selectDate,
    required this.selectedDate,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateSelector(
          selectedDate: selectedDate,
          onDateChanged: (date) => selectDate(date),
        ),
        Expanded(
          child: entries.isEmpty
              ? const Center(child: Text('Нет записей за этот день'))
              : ListView.builder(
            itemCount: entries.length,
            itemBuilder: (ctx, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.name),
                subtitle: Text('${entry.calories?.toStringAsFixed(0) ?? '?'} ккал'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteEntry(entry.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}