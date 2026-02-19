import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/android/android_purchase_wrapper.dart';
import 'package:apphud/models/apphud_models/apphud_non_renewing_purchase.dart';
import 'package:apphud/models/apphud_models/apphud_paywalls.dart';
import 'package:apphud/models/apphud_models/apphud_placement.dart';
import 'package:apphud/models/apphud_models/apphud_subscription.dart';
import 'package:apphud/models/apphud_models/apphud_user.dart';
import 'package:apphud/models/apphud_models/composite/apphud_product_composite.dart';
import 'package:flutter/material.dart';

class MyApphudListener implements ApphudListener {
  final VoidCallback onUpdated;

  MyApphudListener({required this.onUpdated});

  @override
  Future<void> apphudDidChangeUserID(String userId) async {
    print("UserID changed: $userId");
    onUpdated();
  }

  @override
  Future<void> apphudDidFecthProducts(List<ApphudProductComposite> products) async {
    print("Products fetched: ${products.length}");
    onUpdated();
  }

  @override
  Future<void> paywallsDidFullyLoad(ApphudPaywalls paywalls) async {
    print("Paywalls fully loaded");
    onUpdated();
  }

  @override
  Future<void> userDidLoad(ApphudUser user) async {
    print("User loaded: ${user.toString()}");
    onUpdated();
  }

  @override
  Future<void> apphudSubscriptionsUpdated(List<ApphudSubscriptionWrapper> subscriptions) async {
    print("Subscriptions updated: ${subscriptions.length}");
    onUpdated();
  }

  @override
  Future<void> apphudNonRenewingPurchasesUpdated(List<ApphudNonRenewingPurchase> purchases) async {
    print("Non-renewing purchases updated: ${purchases.length}");
    onUpdated();
  }

  @override
  Future<void> placementsDidFullyLoad(List<ApphudPlacement> placements) async {
    print("Placements loaded: ${placements.length}");
    onUpdated();
  }

  @override
  Future<void> apphudDidReceivePurchase(AndroidPurchaseWrapper purchase) async {
    print("Android purchase received: ${purchase.productId}");
    onUpdated();
  }
}
