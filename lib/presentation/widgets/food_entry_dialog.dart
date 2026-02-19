import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';

enum FoodEntryDialogMode { add, edit }

class FoodEntryDialog extends StatefulWidget {
  final Function(String name, double mass, double? calories) onSubmit;
  final FoodEntryDialogMode mode;
  final String buttonText;

  final String? initialName;
  final double? initialMass;
  final double? initialCalories;

  const FoodEntryDialog({
    super.key,
    required this.onSubmit,
    required this.mode,
    required this.buttonText,
    this.initialName,
    this.initialMass,
    this.initialCalories,
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
    _nameController =
        TextEditingController(text: widget.initialName ?? '');
    _massController =
        TextEditingController(text: widget.initialMass?.toString() ?? '');
    _caloriesController =
        TextEditingController(text: widget.initialCalories?.toString() ?? '');
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
    final l10n = context.localizations;

    return AlertDialog(
      title: Text(
        widget.mode == FoodEntryDialogMode.add
            ? l10n.addEntryTitle
            : l10n.editEntryTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.productNameLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _massController,
            decoration: InputDecoration(
              labelText: l10n.massLabel,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            decoration: InputDecoration(
              labelText: l10n.caloriesOptionalLabel,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelButton),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final mass =
                double.tryParse(_massController.text.trim()) ?? 0.0;

            if (name.isNotEmpty && mass > 0) {
              final calories =
              double.tryParse(_caloriesController.text.trim());
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