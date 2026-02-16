import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_eating_app/data/models/food_entry_model.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';


class FirebaseFoodRepository implements FoodRepository {
  final FirebaseFirestore firestore;
  final String userId;

  FirebaseFoodRepository({required this.firestore, required this.userId});

  CollectionReference get _entriesCollection =>
      firestore.collection('users').doc(userId).collection('food_entries');

  @override
  Future<List<FoodEntry>> getEntries() async {
    final snapshot = await _entriesCollection
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => FoodEntryModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<FoodEntry>> getEntriesForPeriod(DateTime start, DateTime end) async {
    final snapshot = await _entriesCollection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => FoodEntryModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> addEntry(FoodEntry entry) async {
    final model = FoodEntryModel.fromEntity(entry);
    await _entriesCollection.doc(entry.id).set(model.toDocument());
  }

  @override
  Future<void> updateEntry(FoodEntry entry) async {
    final model = FoodEntryModel.fromEntity(entry);
    await _entriesCollection.doc(entry.id).update(model.toDocument());
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _entriesCollection.doc(id).delete();
  }
}