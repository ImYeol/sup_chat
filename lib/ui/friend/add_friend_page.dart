import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/icon_button_wrapper.dart';
import 'package:sup_chat/controller/add_friend_controller.dart';
import 'package:sup_chat/ui/friend/friend_search_bar.dart';
import 'package:sup_chat/ui/friend/friend_search_result.dart';

class AddFriendPage extends GetView<AddFriendController> {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FriendSearchBar(
                textEdittingController: controller.textEditingController,
              ),
              Obx(() => FriendSearchResult(
                  searchResult: controller.friendSearchResult))
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      leading: IconButtonWrapper(
        borderColor: Colors.transparent,
        borderRadius: 30,
        borderWidth: 1,
        buttonSize: 60,
        fillColor: Get.theme.scaffoldBackgroundColor,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Get.theme.iconTheme.color,
          size: 24,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        '친구 추가',
        style: Get.textTheme.titleLarge,
      ),
      actions: [],
      centerTitle: false,
      elevation: 0,
    );
  }
}
