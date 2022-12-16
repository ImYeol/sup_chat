import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/choose_status_sheet.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/model/knock.dart';
import 'package:sup_chat/model/message.dart';
import 'package:sup_chat/model/notification.dart';
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

  UserModel get currentUser => userRepository.currentUser.value;
  final _currentUserStatus = UserStatus().obs;
  final _notifications = <Notification>[].obs;
  List<UserModel> get friends => userRepository.friends;
  UserStatus get currentUserStatus => _currentUserStatus.value;
  Map<String, UserStatus> get friendStatusMap => statusRepository.userStatusMap;

  List<Notification> get notifications => _notifications;

  void sendKnock(String friendName) {
    // Get.find<KnockService>().send(Knock(
    //     fromUid: currentUser.uid,
    //     toUid: friend.uid,
    //     updatedAt: DateTime.now()));
    messageRepository.sendPushMessage(
        messageRepository.token, KnockMessageModel(fromName: currentUser.name));
  }

  void sendGroupKnock(List<UserModel> friends) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        messageRepository.sendPushMessage(messageRepository.token,
            KnockMessageModel(fromName: currentUser.name));
      },
    );
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
      if (message.type == MessageType.knock) {
        return Notification(title: title, subTitle: '$title님께서 노크 하였습니다');
      } else {
        return Notification(title: title, subTitle: '$title님께서 친구 요청 하였습니다');
      }
    }).toList();
    _notifications.value = newMessages;
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
    MessageService.instance.init();
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
    MessageService.instance.box.listen(() => onMessageUpdated());
    Get.find<KnockService>().box.listen(() => onKnockReceived());
    super.onReady();
  }

  @override
  void onClose() {
    print("home_controller onClose");
    super.onClose();
  }
}
