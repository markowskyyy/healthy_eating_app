import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/consts/design.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateSelector({super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => onDateChanged(selectedDate.subtract(const Duration(days: 1))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () => onDateChanged(selectedDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }
}