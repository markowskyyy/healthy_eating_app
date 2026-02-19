enum AnalyticsProvider {
  firebase,
  appsflyer,
  appmetrica,
}

extension AnalyticsProviderX on AnalyticsProvider {
  String get key {
    switch (this) {
      case AnalyticsProvider.firebase:
        return 'firebase';
      case AnalyticsProvider.appsflyer:
        return 'appsflyer';
      case AnalyticsProvider.appmetrica:
        return 'appmetrica';
    }
  }
}