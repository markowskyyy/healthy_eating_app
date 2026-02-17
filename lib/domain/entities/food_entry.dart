class FoodEntry {
  final String id;
  final DateTime date;
  final String name;
  final double mass;
  final double? calories;

  const FoodEntry({
    required this.id,
    required this.date,
    required this.name,
    required this.mass,
    this.calories,
  });

  @override
  String toString() {
    final massStr = mass.toStringAsFixed(0);
    final caloriesStr = calories?.toStringAsFixed(0) ?? '?';
    return '$massStr гр / $caloriesStr ккал';
  }
}