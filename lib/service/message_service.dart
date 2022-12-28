import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sup_chat/constants/app_setting.dart';
import 'package:sup_chat/model/message.dart';
import 'package:sup_chat/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showLocalNotification({
  required int id,
  required String title,
  required String body,
  required String payload,
}) async {
  NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails('channel ID', 'channel name',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
          icon: 'launch_background'),
      iOS: DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
        badgeNumber: 1,
        subtitle: 'subtitle',
      ));

  await _flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    notificationDetails,
    payload: payload,
  );
}

@pragma('vm:entry-point')
Future<void> onTerminatedMessage(RemoteMessage message) async {
  print('onTerminatedMessage');
  if (message.notification != null) {
    debugPrint(
        'Message also contained a notification: ${message.notification}');
    final noti = message.notification;
    showLocalNotification(
        id: 1,
        title: noti?.title ?? '',
        body: noti?.body ?? '',
        payload: 'payload');
  }
  // save message locally
  final data = MessageModel(
      fromName: message.data['from_name'],
      type: MessageType.values[int.parse(message.data['msg_type'])],
      createdAt: DateTime.now());
  MessageService.instance.saveMessage(data);
}

class MessageService {
  MessageService._();

  final _token = ''.obs;
  GetStorage box = GetStorage('messages');
  static final instance = MessageService._();

  String get token => _token.value;

  /// `/users/<uid>/fcm_tokens/<docId>` 에 저장을 한다.
  _updateToken(String? token) async {
    if (FirebaseAuth.instance.currentUser == null) return;
    if (token == null) return;
    final ref = Get.find<UserService>().doc;
    print('MessageService _updateToken ref; ${ref.path}');
    await ref.set(
      {
        'device_type': Platform.operatingSystem,
        'fcm_token': token,
      },
      SetOptions(merge: true),
    );
  }

  /// Initialize Messaging
  init() async {
    /// 앱이 실행되는 동안 listen 하므로, cancel 하지 않음.
    /// `/fcm_tokens/<docId>/{token: '...', uid: '...'}`
    /// Save(or update) token
    ///
    FirebaseAuth.instance
        .authStateChanges()
        .listen((user) => _updateToken(token));

    ever(_token, (callback) => _updateToken(token));

    /// Permission request for iOS only. For Android, the permission is granted by default.

    if (kIsWeb || Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      /// Check if permission had given.
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("authorizationStatus denied");
        return _onNotificationPermissionDenied();
      }
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        print("authorizationStatus notDetermined");
        return _onNotificationPermissionNotDetermined();
      }
    }

    // Get the token each time the application loads and save it to database.
    _token.value = await FirebaseMessaging.instance.getToken() ?? '';
    print('MessagingService init ---> device token: $token');

    FirebaseMessaging.onBackgroundMessage(onTerminatedMessage);

    // Handler, when app is on Foreground.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Check if app is opened from CLOSED(TERMINATED) state and get message data.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedFromTermiated(initialMessage);
    }

    // Check if the app is opened(running) from the background state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onMessageOpenedFromBackground(message);
    });

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print('refresh : $token');
      _token.value = token;
    });
    print("box init");
    // init storage
    box.initStorage;
  }

  _onForegroundMessage(RemoteMessage message) {
    debugPrint('Got a message while in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
      final noti = message.notification;
      Get.snackbar(noti?.title ?? '', noti?.body ?? '',
          colorText: Colors.white,
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white,
          ),
          isDismissible: true,
          borderRadius: 0,
          margin: const EdgeInsets.all(0),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.deepPurple,
          progressIndicatorBackgroundColor: Colors.black26,
          barBlur: 80.0,
          forwardAnimationCurve: Curves.easeInSine,
          reverseAnimationCurve: Curves.easeInOutCubic);
      // showLocalNotification(
      //     id: 1,
      //     title: noti?.title ?? '',
      //     body: noti?.body ?? '',
      //     payload: 'payload');

      final data = MessageModel(
          fromName: message.data['from_name'],
          type: MessageType.values[int.parse(message.data['msg_type'])],
          createdAt: DateTime.now());
      MessageService.instance.saveMessage(data);
    }
  }

  _onMessageOpenedFromTermiated(message) {
    // this will triggered when the notification on tray was tap while the app is closed
    // if you change screen right after the app is open it display only white screen.
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      print(message.toString());
    });
  }

  // this will triggered when the notification on tray was tap while the app is open but in background state.
  _onMessageOpenedFromBackground(message) {
    print(message.toString());
  }

  _onNotificationPermissionDenied() {
    print('_onNotificationPermissionDenied');
    // debugPrint('onNotificationPermissionDenied()');
  }

  _onNotificationPermissionNotDetermined() {
    print('_onNotificationPermissionNotDetermined');
    // debugPrint('onNotificationPermissionNotDetermined()');
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String targetToken, MessageModel message) {
    print("constructFCMPayload $targetToken");
    return jsonEncode({
      'notification': {
        'title': message.getTitle(),
        'body': message.getMessage(),
        'sound': 'true'
      },
      'priority': 'high',
      'ttl': '60s',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'msg_type': message.type!.index,
        'from_name': message.fromName
      },
      'to': targetToken
    });
  }

  Future<void> sendPushMessage(String targetToken, MessageModel message) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    print("sendPushMessage $targetToken");
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=${AppSetting.serverKey}'
        },
        body: constructFCMPayload(targetToken, message),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  saveMessage(MessageModel message) {
    print("saveMessage : ${message.hashCode}");
    box.write(message.createdAt.toString(), message.toJson());
    //box.save();
  }

  List<MessageModel> readAll() {
    final messages = <MessageModel>[];
    final keys = box.getKeys();
    print("keys size $keys");
    for (String key in keys) {
      final message = box.read(key);
      messages.insert(0, MessageModel.fromJson(message));
    }
    return messages;
  }

  void remove(String key) {
    box.remove(key);
    box.save();
  }
}
