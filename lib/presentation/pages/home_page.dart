import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/presentation/viewmodels/home/home_viewmodel.dart';
import 'package:healthy_eating_app/presentation/widgets/date_selector.dart';
import 'package:healthy_eating_app/presentation/widgets/home_page_body.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final notifier = ref.watch(homeViewModelProvider.notifier);

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
    final massController = TextEditingController();
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
              controller: massController,
              decoration: const InputDecoration(
                labelText: 'Масса (гр)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // разрешает только цифры
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(
                labelText: 'Калории (необязательно)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // разрешает только цифры
              ],
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
              final mass = double.tryParse(massController.text.trim()) ?? 0.0;
              if (name.isNotEmpty && mass != 0.0) {
                final calories = double.tryParse(caloriesController.text);
                ref.read(homeViewModelProvider.notifier).addEntry(name, mass, calories);
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
