// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';

// Future<void> onTerminatedMessage(RemoteMessage message) async {
//   print('onTerminatedMessage');
//   // update app badger count
// }

// class MessageService extends GetxService {
//   String? token;

//   /// `/users/<uid>/fcm_tokens/<docId>` 에 저장을 한다.
//   _updateToken(String? token) async {
//     if (FirebaseAuth.instance.currentUser == null) return;
//     if (token == null) return;
//     final ref = Get.find<UserService>().doc.collection('fcm_tokens').doc(token);
//     print('ref; ${ref.path}');
//     await ref.set(
//       {
//         'uid': FirebaseAuth.instance.currentUser?.uid,
//         'device_type': Platform.operatingSystem,
//         'fcm_token': token,
//       },
//       SetOptions(merge: true),
//     );
//   }

//   /// Initialize Messaging
//   init() async {
//     // Get the token each time the application loads and save it to database.
//     token = await FirebaseMessaging.instance.getToken() ?? '';
//     print("firebase message token = ${token}");

//     /// 앱이 실행되는 동안 listen 하므로, cancel 하지 않음.
//     /// `/fcm_tokens/<docId>/{token: '...', uid: '...'}`
//     /// Save(or update) token
//     ///
//     FirebaseAuth.instance
//         .authStateChanges()
//         .listen((user) => _updateToken(token));

//     /// Permission request for iOS only. For Android, the permission is granted by default.

//     if (kIsWeb || Platform.isIOS) {
//       NotificationSettings settings =
//           await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       /// Check if permission had given.
//       if (settings.authorizationStatus == AuthorizationStatus.denied) {
//         return _onNotificationPermissionDenied();
//       }
//       if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
//         return _onNotificationPermissionNotDetermined();
//       }
//     }

//     FirebaseMessaging.onBackgroundMessage(onTerminatedMessage);

//     // Handler, when app is on Foreground.
//     FirebaseMessaging.onMessage.listen(_onForegroundMessage);

//     // Check if app is opened from CLOSED(TERMINATED) state and get message data.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _onMessageOpenedFromTermiated(initialMessage);
//     }

//     // Check if the app is opened(running) from the background state.
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _onMessageOpenedFromBackground(message);
//     });

//     // Any time the token refreshes, store this in the database too.
//     FirebaseMessaging.instance.onTokenRefresh
//         .listen((token) => _updateToken(token));
//   }

//   _onForegroundMessage(RemoteMessage message) {
//     debugPrint('Got a message whilst in the foreground!');
//     debugPrint('Message data: ${message.data}');

//     if (message.notification != null) {
//       debugPrint(
//           'Message also contained a notification: ${message.notification}');
//     }
//   }

//   _onMessageOpenedFromTermiated(message) {
//     // this will triggered when the notification on tray was tap while the app is closed
//     // if you change screen right after the app is open it display only white screen.
//     WidgetsBinding.instance.addPostFrameCallback((duration) {
//       print(message.toString());
//     });
//   }

//   // this will triggered when the notification on tray was tap while the app is open but in background state.
//   _onMessageOpenedFromBackground(message) {
//     print(message.toString());
//   }

//   _onNotificationPermissionDenied() {
//     print('_onNotificationPermissionDenied');
//     // debugPrint('onNotificationPermissionDenied()');
//   }

//   _onNotificationPermissionNotDetermined() {
//     print('_onNotificationPermissionNotDetermined');
//     // debugPrint('onNotificationPermissionNotDetermined()');
//   }
// }
