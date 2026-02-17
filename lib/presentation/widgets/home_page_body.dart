import 'package:flutter/material.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/presentation/widgets/date_selector.dart';

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
                subtitle: Text(entry.toString()),
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