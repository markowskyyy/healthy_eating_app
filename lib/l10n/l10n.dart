import 'package:flutter/material.dart';

class L10n {
  static const locals = [
    Locale('ru'),
    Locale('en'),
  ];
}

class LocaleController {
  static final ValueNotifier<Locale?> locale =
  ValueNotifier<Locale?>(null);

  static void set(Locale locale) {
    LocaleController.locale.value = locale;
  }

  static void resetToSystem() {
    LocaleController.locale.value = null;
  }
}