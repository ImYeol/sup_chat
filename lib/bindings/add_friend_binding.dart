import 'package:get/get.dart';
import 'package:sup_chat/controller/add_friend_controller.dart';

class AddFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddFriendController());
  }
}
