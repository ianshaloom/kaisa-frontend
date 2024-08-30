// import 'package:dio/dio.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:intercess/core/utils/utility_methods.dart';

// import 'core/contants.dart';

// class FirebaseNotificationApi {
//   static final _firebaseMessaging = FirebaseMessaging.instance;

//   // request permission
//   static Future<void> requestPermission() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//   }

//   // get FCM Token
//   static Future<String> getFCMToken() async {
//     final token = await _firebaseMessaging.getToken();
//     return token!;
//   }

//   // Handle Token Updates
//   static Stream<String> get handleTokenUpdates {
//     return _firebaseMessaging.onTokenRefresh;
//   }

//   /* --------------------------------[TOKEN Dio Request]----------------------------------- */
//   static void sendFCMTokenToServer(String token) async {
//     final fetchedId = await getDeviceDetails();
//     final id = fetchedId.hashWithSHA256();

//     final body = <String, dynamic>{
//       'id': id,
//       'token': token,
//     };

//     try {
//       final response = await dio
//           .post(kNotificationApiToken, data: body);

//       if (response.statusCode != 200) {
//       }
//     } on DioException catch (_) {
//     }
//   }

//   static Future<String> getDeviceDetails() async {
//     final device = DeviceInfoPlugin();
//     final androidInfo = await device.androidInfo;
//     final identifier =
//         "${androidInfo.manufacturer}${androidInfo.model}${androidInfo.id}";
//     return identifier;
//   }

//   // singleton
//   /* FirebaseNotificationApi._();
//   static final FirebaseNotificationApi _instance = FirebaseNotificationApi._();
//   factory FirebaseNotificationApi() => _instance; */
// }
