import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_eating_app/core/consts/design.dart';


class FoodEntryDialog extends StatefulWidget {
  final Function(String name, double mass, double? calories) onSubmit;
  final String? initialName;
  final double? initialMass;
  final double? initialCalories;
  final String buttonText;

  const FoodEntryDialog({
    super.key,
    required this.onSubmit,
    this.initialName,
    this.initialMass,
    this.initialCalories,
    this.buttonText = 'Добавить',
  });

  @override
  State<FoodEntryDialog> createState() => _FoodEntryDialogState();
}

class _FoodEntryDialogState extends State<FoodEntryDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _massController;
  late final TextEditingController _caloriesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _massController = TextEditingController(
      text: widget.initialMass?.toString() ?? '',
    );
    _caloriesController = TextEditingController(
      text: widget.initialCalories?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _massController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.buttonText == 'Добавить' ? 'Добавить запись' : 'Редактировать запись'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Название продукта',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _massController,
            decoration: const InputDecoration(
              labelText: 'Масса (гр)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            decoration: const InputDecoration(
              labelText: 'Калории (необязательно)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final mass = double.tryParse(_massController.text.trim()) ?? 0.0;
            if (name.isNotEmpty && mass != 0.0) {
              final calories = double.tryParse(_caloriesController.text);
              widget.onSubmit(name, mass, calories);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: Text(widget.buttonText),
        ),
      ],
    );
  }
}