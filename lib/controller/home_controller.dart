import 'package:get/get.dart';
import 'package:sup_chat/component/choose_status_sheet.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/model/knock.dart';
import 'package:sup_chat/model/notification.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/knock_service.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class HomeController extends GetxController {
  final userRepository = Get.find<UserService>();
  final statusRepository = Get.find<StatusService>();

  UserModel get currentUser => userRepository.currentUser.value;
  final _currentUserStatus = UserStatus().obs;
  List<UserModel> get friends => userRepository.friends;
  UserStatus get currentUserStatus => _currentUserStatus.value;
  Map<String, UserStatus> get friendStatusMap => statusRepository.userStatusMap;

  List<Notification> get notifications =>
      [Notification(title: '친구 상태가 변경되었습니다')];

  void sendKnock(String friendName) {
    // Get.find<KnockService>().send(Knock(
    //     fromUid: currentUser.uid,
    //     toUid: friend.uid,
    //     updatedAt: DateTime.now()));
    statusRepository.update(
        'Fm85jBXVsXPNXE1ICa9j6MZoatDd',
        UserStatus(
            name: 'test2', statusType: StatusType.BIKE, comment: 'asdf11'));
  }

  void sendGroupKnock(List<UserModel> friends) {}

  void addFriendIfResultExist() async {
    final result = await Get.toNamed(AppRoute.ADD_FRIEND);
    if (result != null) {
      final friend = result as UserModel;
      userRepository.addFriend(friend);
    }
  }

  void confirmFriendStatus() {}

  void selectFriendsForGroupKnock() {}

  void selectStatus() {
    Get.bottomSheet(ChooseStatusSheet());
  }

  void onStatusError() {}

  void onKnockReceived() {
    final knockBox = Get.find<KnockService>().box;
    print("onKnockReceived changes = ${knockBox.changes}");
  }

  void updateUserStatus(UserModel? user, {UserStatus? status}) async {
    print("updateUserStatus : user= $user");
    if (user == null) {
      print('user is null');
      return;
    }
    final userStatus = status ?? await statusRepository.read(user.uid);
    print("updateUserStatus : status= $userStatus");
    if (user.uid != currentUser.uid) {
      statusRepository.observeUserStatusRef(user.uid);
      statusRepository.update(user.uid, userStatus, useCache: true);
      statusRepository.userStatusMap.refresh();
    } else {
      _currentUserStatus.value = userStatus;
    }
  }

  @override
  void onInit() {
    print("home_controller onInit");
    Get.find<UserService>().init();
    super.onInit();
  }

  @override
  void onReady() {
    print("home_controller onReady");
    // update friends and status
    once(userRepository.currentUser, (user) => updateUserStatus(user));
    ever(userRepository.friends, (friendList) {
      print("friends changed $friendList");
      statusRepository.unobserveUserStatusRef();
      friendList.forEach(updateUserStatus);
    });
    Get.find<KnockService>().box.listen(() => onKnockReceived());
    super.onReady();
  }

  @override
  void onClose() {
    print("home_controller onClose");
    super.onClose();
  }
}
