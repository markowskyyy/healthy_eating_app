import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';


class FoodEntryModel extends FoodEntry {
  const FoodEntryModel({
    required super.id,
    required super.date,
    required super.name,
    required super.mass,
    super.calories,
  });

  /// Создание модели из документа Firestore
  factory FoodEntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodEntryModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      name: data['name'] as String,
      mass: (data['mass'] as num).toDouble(),
      calories: (data['calories'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'date': Timestamp.fromDate(date),
      'name': name,
      'mass': mass,
      'calories': calories,
    };
  }

  factory FoodEntryModel.fromEntity(FoodEntry entity) {
    return FoodEntryModel(
      id: entity.id,
      date: entity.date,
      name: entity.name,
      mass: entity.mass,
      calories: entity.calories,
    );
  }
}