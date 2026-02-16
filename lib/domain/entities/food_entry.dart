class FoodEntry {
  final String id;
  final DateTime date;
  final String name;
  final double? calories;

  const FoodEntry({
    required this.id,
    required this.date,
    required this.name,
    this.calories,
  });
}