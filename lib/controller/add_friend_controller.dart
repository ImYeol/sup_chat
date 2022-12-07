import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/service/user_service.dart';

class AddFriendController extends GetxController {
  final _friendSearchResult = UserModel(createdAt: Timestamp.now()).obs;
  final TextEditingController _textEditingController = TextEditingController();

  UserModel get friendSearchResult => _friendSearchResult.value;
  TextEditingController get textEditingController => _textEditingController;

  void searchFriend(String name) async {
    print("searchFriend = $name");
    if (name.isEmpty) _friendSearchResult.value = UserModel();
    _friendSearchResult.value =
        await Get.find<UserService>().getUserByName(name, useCache: false);
  }

  void addFriend(UserModel friend) {
    Get.find<UserService>()
        .addFriend(friend)
        .then((value) => Get.back(result: friend));
  }
}
