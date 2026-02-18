// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:appsflyer_sdk/appsflyer_sdk.dart'; // ваш импорт
//
// Future<void> requestTrackingAuthorization(AppsflyerSdk appsflyerSdk) async {
//   // Запрос разрешения (доступно только на iOS 14+)
//   final status = await AppTrackingTransparency.requestTrackingAuthorization();
//
//   // Обработка статуса и передача в AppsFlyer
//   _handleTrackingStatus(status, appsflyerSdk);
// }
//
// void _handleTrackingStatus(TrackingStatus status, AppsflyerSdk appsflyerSdk) {
//   // Преобразуем статус в int (значения ATTrackingManager.AuthorizationStatus)
//   final int attStatus = _mapTrackingStatusToInt(status);
//
//   // Передаём статус в AppsFlyer
//   // В вашей версии SDK метод может называться setTrackingAuthorizationStatus
//   // Если такого метода нет, проверьте документацию вашего пакета.
//   try {
//     appsflyerSdk.setTrackingAuthorizationStatus(attStatus);
//   } catch (e) {
//     print('Метод setTrackingAuthorizationStatus не найден. Проверьте документацию.');
//     // Альтернатива: некоторые версии используют updateServerUninstallToken или setPartnerData
//     // но лучше обновить SDK до актуальной версии.
//   }
//
//   // Логируем для отладки
//   print('ATT Status: $status');
// }
//
// int _mapTrackingStatusToInt(TrackingStatus status) {
//   switch (status) {
//     case TrackingStatus.authorized:
//       return 3;
//     case TrackingStatus.denied:
//       return 2;
//     case TrackingStatus.notDetermined:
//       return 0;
//     case TrackingStatus.restricted:
//       return 1;
//     default:
//       return 0;
//   }
// }