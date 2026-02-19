import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';
import 'package:healthy_eating_app/presentation/widgets/date_selector.dart';

class HomePageBody extends StatelessWidget {
  final Function(String id) deleteEntry;
  final Function(DateTime date) selectDate;
  final Function(FoodEntry) onEditEntry;
  final DateTime selectedDate;
  final List<FoodEntry> entries;
  const HomePageBody({
    super.key,
    required this.deleteEntry,
    required this.onEditEntry,
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
              ? Center(
                  child: Text(
                    context.localizations.noEntriesForDay,
                    style: AppTextStyles.body,
                  ),
                )
              : ListView.builder(
            itemCount: entries.length,
            itemBuilder: (ctx, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.name, style: AppTextStyles.subtitle),
                subtitle: Text(entry.toString(), style: AppTextStyles.body),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => onEditEntry(entry),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteEntry(entry.id),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}