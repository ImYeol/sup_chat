import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/choose_status_sheet.dart';
import 'package:sup_chat/constants/app_route.dart';
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

  StreamSubscription? friendsSubscription;
  StreamSubscription? messageSubscription;

  UserModel get currentUser => userRepository.currentUser.value;
  final _currentUserStatus = UserStatus().obs;
  final _notifications = <NotificationModel>[].obs;
  List<UserModel> get friends => userRepository.friends;
  UserStatus get currentUserStatus => _currentUserStatus.value;
  Map<String, UserStatus> get friendStatusMap => statusRepository.userStatusMap;

  List<NotificationModel> get notifications => _notifications;

  void sendKnock(String friendName) {
    // Get.find<KnockService>().send(Knock(
    //     fromUid: currentUser.uid,
    //     toUid: friend.uid,
    //     updatedAt: DateTime.now()));
    final friend = friends.firstWhere((user) => user.name == friendName);
    messageRepository
        .sendPushMessage(
            friend.token, KnockMessageModel(fromName: currentUser.name))
        .then((value) => Get.snackbar('노크노크', '$friendName님에게 노크를 보냈습니다',
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
            reverseAnimationCurve: Curves.easeInOutCubic));
  }

  void sendGroupKnock(List<UserModel> friends) {
    Get.snackbar('test snackbar', 'message',
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
        forwardAnimationCurve: Curves.bounceIn,
        reverseAnimationCurve: Curves.easeInOutCubic, snackbarStatus: (status) {
      if (status == SnackbarStatus.CLOSED) {
        print("login snackbar closed");
        //Get.offNamed(AppRoute.HOME);
      } else if (status == SnackbarStatus.OPEN) {
        print("login snackbar open");
      } else if (status == SnackbarStatus.CLOSING) {
        print("login snackbar closing");
        Get.closeCurrentSnackbar();
      }
    });
  }

  void addFriendIfResultExist() async {
    final result = await Get.toNamed(AppRoute.ADD_FRIEND);
    if (result != null) {
      final friend = result as UserModel;
      userRepository.addFriend(friend);
    }
  }

  void confirmFriendStatus() {}

  void selectFriendsForGroupKnock() {}

  void selectStatus() async {
    final userStatus = await Get.bottomSheet(
        StatusSelectionSheet(
          userStatus: currentUserStatus,
        ),
        isScrollControlled: true);
    if (userStatus != null) {
      _currentUserStatus.update((status) {
        status?.name = userStatus.name ?? status.name;
        status?.comment = userStatus.comment ?? '';
        status?.statusType = userStatus.statusType;
      });
    }
    print("seletStatus done - $_currentUserStatus");
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
    //_notifications.remove(notification);
  }

  Future<void> updateUserStatus(UserModel? user, {UserStatus? status}) async {
    print("updateUserStatus1 : user= $user");
    if (user == null) {
      print('user is null');
      return;
    }
    final userStatus = status ?? await statusRepository.read(user.uid);
    print("updateUserStatus2 : status= $userStatus");
    if (user.uid != currentUser.uid) {
      print("updateUserStatus3 : user update");
      statusRepository.observeUserStatusRef(user.uid);
      statusRepository.update(user.uid, userStatus, useCache: true);
      statusRepository.userStatusMap.refresh();
    } else {
      print("updateUserStatus3 : current user update");
      _currentUserStatus.value = userStatus;
    }
  }

  @override
  void onInit() {
    print("home_controller onInit");
    //Get.find<UserService>().init();
    MessageService.instance.init();
    userRepository.init();
    // once(userRepository.friends, (friendList) async {
    //   print("friends changed ${friendList.length}");
    //   statusRepository.unobserveUserStatusRef();
    //   for (int i = 0; i < friendList.length; i++) {
    //     await updateUserStatus(friendList[i]);
    //   }
    // });
    friendsSubscription = userRepository.friends.listen((friendList) async {
      print("friends changed ${friendList.length}");
      statusRepository.unobserveUserStatusRef();
      for (int i = 0; i < friendList.length; i++) {
        await updateUserStatus(friendList[i]);
      }
    });
    MessageService.instance.box.listen(() => onMessageUpdated());
    super.onInit();
  }

  @override
  void onReady() {
    print("home_controller onReady");
    // update friends and status
    //once(userRepository.currentUser, (user) => updateUserStatus(user));
    updateUserStatus(userRepository.currentUser.value);
    userRepository.loadFriends();
    super.onReady();
  }

  @override
  void onClose() {
    print("home_controller onClose");
    statusRepository.clear();
    userRepository.clear();
    friendsSubscription?.cancel();
    super.onClose();
  }
}
