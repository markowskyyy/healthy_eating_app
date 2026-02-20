import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-9376717320250525/5942430388';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9376717320250525/5443182418';
      return ''; //
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}