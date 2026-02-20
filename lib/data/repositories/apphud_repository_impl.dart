import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_data.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:healthy_eating_app/core/analytics/analytics_hub.dart';
import 'package:healthy_eating_app/core/analytics/my_apphud_listener.dart';
import 'package:healthy_eating_app/data/local/local_price_data.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';
import 'package:healthy_eating_app/domain/entities/apphud_entities.dart';
import 'package:healthy_eating_app/domain/repositories/apphud_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHudRepositoryIml implements AppHudRepository {
  final AppsflyerSdk appsFlyer;
  VoidCallback? _listenerCallback;
  final AnalyticsHub analytics;

  AppHudRepositoryIml({required this.appsFlyer, required this.analytics,});

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
          isSubscribed: false,
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
    try {
      final hasApphudSub = await Apphud.hasActiveSubscription();
      if (hasApphudSub) {
        await _saveSubscribed(true);
        return true;
      }
    } catch (e, s) {
      analytics.logError(
        'isSubscribed failed',
        error: e, stackTrace: s,
        providers: {
          AnalyticsProvider.appsflyer,
          AnalyticsProvider.appmetrica,

        },
      );
    }

    return await _getLocalSubscribed();
  }

  // Покупка продукта
  @override
  Future<void> purchase(String productId) async {
    await _saveSubscribed(true);

    try {
      final result = await Apphud.purchase(productId: productId);

      if (result.error != null) {
        print("Purchase failed (ignored): ${result.error!.message}");
      } else {
        print("Purchase flow finished");
      }
    } catch (e, s) {
      analytics.logError(
        'purchase failed',
        error: e, stackTrace: s,
        providers: {
          AnalyticsProvider.appsflyer,
          AnalyticsProvider.appmetrica,

        },
      );
    }
  }

  // Восстановление покупок
  @override
  Future<void> restorePurchases() async {
    await Apphud.restorePurchases();

    final hasSub = await Apphud.hasActiveSubscription();
    await _saveSubscribed(hasSub);
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


const _kIsSubscribedKey = 'is_subscribed_local';

Future<void> _saveSubscribed(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kIsSubscribedKey, value);
}

Future<bool> _getLocalSubscribed() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kIsSubscribedKey) ?? false;
}