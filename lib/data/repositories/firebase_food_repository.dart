import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';
import 'package:healthy_eating_app/data/models/food_entry_model.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';


class FirebaseFoodRepository implements FoodRepository {
  final FirebaseFirestore firestore;
  final String userId;
  final AnalyticsService analytics;

  FirebaseFoodRepository({
    required this.firestore,
    required this.userId,
    required this.analytics,
  });

  CollectionReference get _entriesCollection =>
      firestore.collection('users').doc(userId).collection('food_entries');

  @override
  Future<List<FoodEntry>> getEntries() async {
    try {
      final snapshot = await _entriesCollection
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => FoodEntryModel.fromFirestore(doc))
          .toList();
    } catch (e, s) {
      analytics.logError('getEntries failed', error: e, stackTrace: s);
      rethrow; // или вернуть пустой список, в зависимости от логики
    }
  }

  @override
  Future<List<FoodEntry>> getEntriesForPeriod(DateTime start, DateTime end) async {
    try {
      final snapshot = await _entriesCollection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => FoodEntryModel.fromFirestore(doc))
          .toList();
    } catch (e, s) {
      analytics.logError('getEntriesForPeriod failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> addEntry(FoodEntry entry) async {
    try {
      final model = FoodEntryModel.fromEntity(entry);
      await _entriesCollection.doc(entry.id).set(model.toDocument());
    } catch (e, s) {
      analytics.logError('addEntry failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> updateEntry(FoodEntry entry) async {
    try {
      final model = FoodEntryModel.fromEntity(entry);
      await _entriesCollection.doc(entry.id).update(model.toDocument());
    } catch (e, s) {
      analytics.logError('updateEntry failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      await _entriesCollection.doc(id).delete();
    } catch (e, s) {
      analytics.logError('deleteEntry failed', error: e, stackTrace: s);
      rethrow;
    }
  }
}