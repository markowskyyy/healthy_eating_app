class AppHudProduct {
  final String id;
  final String name;
  final double price;
  final String currencyCode;
  final bool isSubscribed;

  AppHudProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.currencyCode,
    required this.isSubscribed,
  });
}

class AppHudPaywall {
  final String id;
  final String name;
  final List<AppHudProduct> products;

  AppHudPaywall({
    required this.id,
    required this.name,
    required this.products,
  });
}

class AppHudPlacement {
  final String id;
  final AppHudPaywall? paywall;

  AppHudPlacement({required this.id, this.paywall});
}

