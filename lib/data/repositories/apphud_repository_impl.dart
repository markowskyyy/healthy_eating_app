import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_data.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/analytics/my_apphud_listener.dart';
import 'package:healthy_eating_app/data/local/local_price_data.dart';
import 'package:healthy_eating_app/domain/entities/apphud_entities.dart';
import 'package:healthy_eating_app/domain/repositories/apphud_repository.dart';

class AppHudRepositoryIml implements AppHudRepository {
  final AppsflyerSdk appsFlyer;
  VoidCallback? _listenerCallback;

  AppHudRepositoryIml({required this.appsFlyer});

  // Получение placements и связанного paywall
  Future<void> showPaywall(String placementId) async {
    final placementsData = await Apphud.paywallsDidLoadCallback();
    final placements = placementsData.paywalls ?? [];

    final placement = placements.firstWhere(
      (p) => p.identifier == placementId,
    );

    if (placement != null && placement.products != null) {
      final paywall = placement;
      final products = paywall.products!;

      // Здесь можно показать UI с продуктами
      print("Paywall loaded with ${products.length} products");

      // Сообщаем Apphud, что paywall показан
      await Apphud.paywallShown(paywall);
    }
  }

// Совершение покупки продукта
  Future<void> buyProduct(String productId) async {
    final result = await Apphud.purchase(productId: productId);

    if (result.error != null) {
      print("Purchase failed: ${result.error!.message}");
      return;
    }

    if (result.subscription != null && result.subscription!.isActive) {
      print("Subscription active: ${result.subscription!.productId}");
    } else if (result.nonRenewingPurchase != null && result.nonRenewingPurchase!.isActive) {
      print("Non-renewing purchase active: ${result.nonRenewingPurchase!.productId}");
    } else {
      print("Purchase completed but inactive or unknown status");
    }
  }


  // Получение всех paywalls с продуктами
  @override
  Future<List<AppHudPlacement>> getPlacements() async {
    final placementsData = await Apphud.paywallsDidLoadCallback();
    final paywalls = placementsData.paywalls ?? [];

    return paywalls.map((paywall) {
      final products = paywall.products?.map((product) {
        final price = localPrices[product.productId] ?? 0.0;
        final currencyCode = localCurrency[product.productId] ?? 'USD';

        return AppHudProduct(
          id: product.productId,
          name: product.name ?? '',
          price: price,
          currencyCode: currencyCode,
          isSubscribed: false, // Будет обновлено через Apphud subscription
        );
      }).toList() ?? [];

      final appHudPaywall = AppHudPaywall(
        id: paywall.identifier,
        name: paywall.identifier,
        products: products,
      );

      return AppHudPlacement(
        id: paywall.identifier,
        paywall: appHudPaywall,
      );
    }).toList();
  }

  // Получение активных подписок
  @override
  Future<List<AppHudProduct>> getActiveSubscriptions() async {
    final subscriptions = await Apphud.subscriptions();


    return subscriptions.where((s) => s.isActive).map((s) {

      final price = localPrices[s.productId] ?? 0.0;
      final currencyCode = localCurrency[s.productId] ?? 'USD';
        return AppHudProduct(
          id: s.productId,
          name: s.productId,
          price: price,
          currencyCode: currencyCode,
          isSubscribed: true,
        );
    }).toList();
  }

  // Проверка активной подписки
  @override
  Future<bool> isSubscribed() async {
    return await Apphud.hasActiveSubscription();
  }

  // Покупка продукта
  @override
  Future<void> purchase(String productId) async {
    final result = await Apphud.purchase(productId: productId);

    if (result.error != null) {
      print("Purchase failed: ${result.error!.message}");
      return;
    }

    if (result.subscription != null) {
      print("Subscription purchased: ${result.subscription!.productId}");
    }

    if (result.nonRenewingPurchase != null) {
      print("Non-renewing purchase completed: ${result.nonRenewingPurchase!.productId}");
    }
  }

  // Восстановление покупок
  @override
  Future<void> restorePurchases() async {
    await Apphud.restorePurchases();
  }

  // Подписка на обновления AppHud
  @override
  void addListener(void Function() listener) {
    _listenerCallback = listener;

    Apphud.setListener(
      listener: MyApphudListener(onUpdated: _listenerCallback!),
    );
  }

  @override
  void removeListener(void Function() listener) {
    if (_listenerCallback == listener) {
      _listenerCallback = null;
      Apphud.setListener(listener: null);
    }
  }

  // Отправка атрибуции AppsFlyer в AppHud
  Future<void> sendAppsFlyerAttribution(Map<String, dynamic> afData, String appsFlyerUID) async {
    await Apphud.setAttribution(
      provider: ApphudAttributionProvider.appsFlyer,
      data: ApphudAttributionData(rawData: afData),
      identifier: appsFlyerUID,
    );
  }
}
