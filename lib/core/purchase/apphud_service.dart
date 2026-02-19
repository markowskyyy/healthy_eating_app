// import 'dart:async';
// import 'package:apphud/apphud.dart';
// import 'package:apphud/models/apphud_models/apphud_paywall.dart';
// import 'package:flutter/foundation.dart';
//
// class AppHudService {
//   static final AppHudService _instance = AppHudService._internal();
//   factory AppHudService() => _instance;
//   AppHudService._internal();
//
//   StreamSubscription? _subscriptionListener;
//
//   Future<void> init() async {
//     await Apphud.start(apiKey: 'app_Z44sHCCXqhP5FCBDa8SxKBLB7VLpga');
//
//     _subscriptionListener = Apphud.subscriptionUpdates.listen((subscriptions) {
//       debugPrint("Subscription updated: $subscriptions");
//     });
//   }
//
//   // ---------- STATUS ----------
//   Future<bool> hasPremium() async {
//     final subscriptions = await Apphud.subscriptions();
//     return subscriptions.any((sub) => sub.isActive());
//   }
//
//   // ---------- PAYWALL ----------
//   Future<ApphudPaywall?> getMainPaywall() async {
//     final paywalls = await Apphud.paywalls();
//     return paywalls.firstWhere(
//           (p) => p.identifier == "main_paywall",
//       orElse: () => null,
//     );
//   }
//
//   Future<List<ApphudProduct>> getProducts() async {
//     final paywall = await getMainPaywall();
//     return paywall?.products ?? [];
//   }
//
//   // ---------- PRICE ----------
//   String getLocalizedPrice(ApphudProduct product) {
//     return product.skProduct?.price?.toString() ?? "";
//   }
//
//   String getCurrency(ApphudProduct product) {
//     return product.skProduct?.priceLocale?.currencyCode ?? "";
//   }
//
//   // ---------- PURCHASE ----------
//   Future<void> purchase(ApphudProduct product) async {
//     final result = await Apphud.purchase(product: product);
//
//     if (result?.subscription?.isActive() == true) {
//       debugPrint("Purchase successful");
//     }
//   }
//
//   // ---------- RESTORE ----------
//   Future<void> restore() async {
//     await Apphud.restorePurchases();
//   }
//
//   void dispose() {
//     _subscriptionListener?.cancel();
//   }
// }
