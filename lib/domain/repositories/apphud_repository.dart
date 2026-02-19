import 'package:healthy_eating_app/domain/entities/apphud_entities.dart';

abstract class AppHudRepository {
  Future<List<AppHudPlacement>> getPlacements();
  Future<List<AppHudProduct>> getActiveSubscriptions();
  Future<bool> isSubscribed();
  Future<void> purchase(AppHudProduct product);
  Future<void> restorePurchases();
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}
