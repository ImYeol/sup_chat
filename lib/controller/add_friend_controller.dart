import 'package:get/get.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/service/user_service.dart';

class AddFriendController extends GetxController {

  Future<UserModel> searchFriend(String name) async {
    return Get.find<UserService>().getUserByName(name);
  }
}
