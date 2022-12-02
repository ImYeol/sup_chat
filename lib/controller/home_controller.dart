import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/knock.dart';
import 'package:sup_chat/model/notification.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/knock_service.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class HomeController extends GetxController {
  final repository = Get.find<StatusService>();
  final _friends = <UserModel>[].obs;
  final _userStatusMap = <String, UserStatus>{}.obs;
  List<StreamSubscription>? _friendStatusSubscriptions;

  UserModel? get user => Get.find<UserService>().currentUser;
  List<UserModel> get friends => _friends.value;
  Map<String, UserStatus> get userStatusMap => _userStatusMap;

  List<Notification> get notifications =>
      [Notification(title: '친구 상태가 변경되었습니다')];

  void sendKnock(UserModel friend) {
    if (user != null) {
      Get.find<KnockService>().send(Knock(
          fromUid: user!.uid, toUid: friend.uid, updatedAt: DateTime.now()));
    }
  }

  void sendGroupKnock(List<UserModel> friends) {}

  void addFriend() {}

  void confirmFriendStatus() {}

  void selectFriendsForGroupKnock() {}

  void onStatusChanged(DatabaseEvent event) {
    final snapshot = (event.snapshot.value ?? {}) as Map<String, dynamic>;
    final status = UserStatus.fromJson(snapshot);
    final uid = event.snapshot.key;
    print("onStatusChanged key = ${event.snapshot.key}, status = $status");
    if (uid == null) return;
    repository.update(uid, status);
    updateUserStatus(uid);
  }

  void onStatusError() {}

  void onKnockReceived() {
    final knockBox = Get.find<KnockService>().box;
    print("onKnockReceived changes = ${knockBox.changes}");
  }

  void updateFriends(List<UserModel>? friends) {
    _friendStatusSubscriptions ??= List<StreamSubscription>.empty();
    friends?.map((friend) async {
      _friendStatusSubscriptions!.add(repository.observeUserStatusRef(
          friend.uid, onStatusChanged,
          onError: onStatusError));
      updateUserStatus(friend.uid);
    });
    _friends.value = friends ?? <UserModel>[];
  }

  void updateUserStatus(String uid) async {
    var status = await repository.read(uid);
    _userStatusMap.update(uid, (value) => status ?? UserStatus(),
        ifAbsent: () => status ?? UserStatus());
  }

  @override
  void onReady() {
    _friends.value = List<UserModel>.empty();
    // update user status
    if (user != null) {
      Get.find<KnockService>().box.listen(() => onKnockReceived());
    }
    // update friends and status
    Get.find<UserService>()
        .getFriends()
        .then((friends) => updateFriends(friends));
    super.onReady();
  }

  @override
  void onClose() {
    _friendStatusSubscriptions?.map((subscription) => subscription.cancel());
    print("_friendStatusSubscriptions : ${_friendStatusSubscriptions?.length}");
    _userStatusMap.clear();
    super.onClose();
  }
}
