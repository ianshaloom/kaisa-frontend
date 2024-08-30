
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'notification_ds.dart';

// class FirebaseNotifApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialise() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );

//     await _firebaseMessaging.getToken().then((token) {
//       if (token != null) FirebaseNotificationApi.sendFCMTokenToServer(token);
//     });
//   }
// }
