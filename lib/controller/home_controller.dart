import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/notification.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class HomeController extends GetxController {
  final _friends = <UserModel>[].obs;
  Map<String, UserStatus>? _userStatusMap;
  List<StreamSubscription>? _friendStatusSubscriptions;

  UserModel? get user => Get.find<UserService>().currentUser;

  List<UserModel> get friends => _friends.value;
  Map<String, UserStatus>? get userStatusMap => _userStatusMap;

  List<Notification> get notifications =>
      [Notification(title: '친구 상태가 변경되었습니다')];

  void onStatusChanged(DatabaseEvent event) {
    final snapshot = (event.snapshot.value ?? {}) as Map<String, dynamic>;
    final status = UserStatus.fromJson(snapshot);
    print('UserStatusRef event fired = $status');
  }

  void onStatusError() {}

  void updateFriends(List<UserModel>? friends) {
    final statusService = Get.find<StatusService>();
    _userStatusMap ??= <String, UserStatus>{};
    _friendStatusSubscriptions ??= List<StreamSubscription>.empty();
    friends?.map((friend) async {
      _friendStatusSubscriptions!.add(statusService.observeUserStatusRef(
          friend.uid, onStatusChanged,
          onError: onStatusError));
      _userStatusMap?[friend.name] =
          (await statusService.read(friend.uid)) as UserStatus;
    });
    _friends.value = friends ?? <UserModel>[];
  }

  @override
  void onReady() {
    _friends.value = List<UserModel>.empty();
    Get.find<UserService>()
        .getFriends()
        .then((friends) => updateFriends(friends));
    super.onReady();
  }

  @override
  void onClose() {
    _friendStatusSubscriptions?.map((subscription) => subscription.cancel());
    _friendStatusSubscriptions?.clear();
    _userStatusMap?.clear();
    super.onClose();
  }
}
