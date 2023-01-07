import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/friend_model.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/service/user_service.dart';

class AddFriendController extends GetxController {
  final _friendSearchResult = FriendModel().obs;
  final TextEditingController _textEditingController = TextEditingController();

  FriendModel get friendSearchResult => _friendSearchResult.value;
  TextEditingController get textEditingController => _textEditingController;

  void searchFriend(String name) async {
    print("searchFriend = $name");
    if (name.isEmpty) _friendSearchResult.value = FriendModel();
    _friendSearchResult.value = await Get.find<UserService>()
            .searchFriendByName(name, useCache: false) ??
        FriendModel();
  }

  void addFriend(FriendModel friend) {
    Get.find<UserService>()
        .sendFriendRequest(friend.uid!, friend.name!)
        .then((value) => Get.back(result: friend));
  }
}
