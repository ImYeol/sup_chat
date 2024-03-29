import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/choose_status_sheet.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/model/friend_model.dart';
import 'package:sup_chat/model/knock.dart';
import 'package:sup_chat/model/message.dart';
import 'package:sup_chat/model/notification_model.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/knock_service.dart';
import 'package:sup_chat/service/message_service.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class HomeController extends GetxController {
  final userRepository = Get.find<UserService>();
  final statusRepository = Get.find<StatusService>();
  final messageRepository = MessageService.instance;

  StreamSubscription? messageSubscription;

  UserModel get currentUser => userRepository.currentUser.value;
  List<FriendModel> get friends => userRepository.friends;
  Map<String, UserStatus> get userStatusMap => statusRepository.userStatusMap;

  final _notifications = <NotificationModel>[].obs;

  List<NotificationModel> get notifications => _notifications;

  void sendKnock(String friendName) {
    final friend = friends.firstWhere((user) => user.name == friendName);
    if (messageRepository.tokens[friend.uid] != '') {
      messageRepository
          .sendPushMessage(messageRepository.tokens[friend.uid]?.token ?? '',
              KnockMessageModel(fromName: currentUser.name))
          .then((value) =>
              showNotificationMessage('노크노크', '$friendName님에게 노크를 보냈습니다'));
    } else {}
  }

  void sendGroupKnock(List<FriendModel> friends) {
    Future.delayed(
        Duration(seconds: 3),
        () => messageRepository.sendPushMessage(messageRepository.token,
            KnockMessageModel(fromName: currentUser.name)));
    // Get.snackbar('test snackbar', 'message',
    //     colorText: Colors.white,
    //     icon: const Icon(
    //       Icons.send_rounded,
    //       color: Colors.white,
    //     ),
    //     isDismissible: true,
    //     borderRadius: 0,
    //     margin: const EdgeInsets.all(0),
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.deepPurple,
    //     progressIndicatorBackgroundColor: Colors.black26,
    //     barBlur: 80.0,
    //     forwardAnimationCurve: Curves.bounceIn,
    //     reverseAnimationCurve: Curves.easeInOutCubic, snackbarStatus: (status) {
    //   if (status == SnackbarStatus.CLOSED) {
    //     print("login snackbar closed");
    //     //Get.offNamed(AppRoute.HOME);
    //   } else if (status == SnackbarStatus.OPEN) {
    //     print("login snackbar open");
    //   } else if (status == SnackbarStatus.CLOSING) {
    //     print("login snackbar closing");
    //     Get.closeCurrentSnackbar();
    //   }
    // });
  }

  void showNotificationMessage(String title, String message) {
    Get.snackbar(title, message,
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
  }

  void addFriendIfResultExist() async {
    final result = await Get.toNamed(AppRoute.ADD_FRIEND);
    // if (result != null) {
    //   final friend = result as FriendModel;
    //   userRepository.addFriend(friend);
    // }
  }

  void confirmFriendStatus() {}

  void selectFriendsForGroupKnock() {}

  void selectStatus() async {
    final userStatus = await Get.bottomSheet(
        StatusSelectionSheet(
          userStatus: userStatusMap[currentUser.uid] ?? UserStatus(),
        ),
        isScrollControlled: true);
    if (userStatus != null) {
      userStatusMap[currentUser.uid] = userStatus as UserStatus;
    }
    print("seletStatus done - $userStatus");
  }

  void onStatusError() {}

  void onKnockReceived() {
    final knockBox = Get.find<KnockService>().box;
    print("onKnockReceived changes = ${knockBox.changes}");
  }

  void onMessageUpdated() {
    var messages = messageRepository.readAll();
    var newMessages = messages.map((message) {
      String title = message.fromName ?? '';
      print("onMessageUpdated : $message");
      if (message.type == MessageType.knock) {
        return NotificationModel(
            title: title,
            subTitle: '$title님께서 노크 하였습니다',
            createdAt: message.createdAt ?? DateTime.now());
      } else {
        return NotificationModel(
            title: title,
            subTitle: '$title님께서 친구 요청 하였습니다',
            createdAt: message.createdAt ?? DateTime.now());
      }
    }).toList();
    _notifications.value = newMessages;
  }

  void onMessageDeleted(NotificationModel notification) {
    print(
        "onMessageDeleted = key: ${notification.createdAt} message: $notification");
    messageRepository.remove(notification.createdAt.toString());
  }

  @override
  void onInit() {
    print("home_controller onInit");
    //Get.find<UserService>().init();
    MessageService.instance.init();
    MessageService.instance.box.listen(() => onMessageUpdated());
    super.onInit();
  }

  @override
  void onReady() {
    print("home_controller onReady");
    super.onReady();
  }

  @override
  void onClose() {
    print("home_controller onClose");
    super.onClose();
  }
}
