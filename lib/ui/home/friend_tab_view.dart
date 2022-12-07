import 'package:flutter/material.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/component/icon_button_wrapper.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/user_status_card.dart';
import 'package:sup_chat/component/user_status_icon.dart';
import 'package:sup_chat/controller/home_controller.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_status.dart';

class FriendTabView extends StatelessWidget {
  final controller = Get.find<HomeController>();

  FriendTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Obx(() => buildFriendListView(controller.friendStatusMap)),
        ),
        buildBottomMenu()
      ],
    );
  }

  Widget buildFriendListView(Map<String, UserStatus> friendStatusMap) {
    final friendStatusList = friendStatusMap.values.toList();
    print("friends size = ${friendStatusList.length}");
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          scrollDirection: Axis.vertical,
          itemCount: friendStatusList.length,
          itemBuilder: (context, index) => InkWell(
                onDoubleTap: () =>
                    controller.sendKnock(friendStatusList[index].name ?? ''),
                onTap: () => controller.confirmFriendStatus(),
                onLongPress: () => controller.selectFriendsForGroupKnock(),
                child: UserStatusCard(
                  icon: UserStatusIcon(iconData: Icons.directions_bike_rounded),
                  displayText: friendStatusList[index].name,
                  statusText: mapStatusTypeToString[
                          friendStatusList[index].statusType] ??
                      '초기상태',
                  labelText: friendStatusList[index].comment ?? '',
                ),
              )),
    );
  }

  Widget buildBottomMenu() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildGroupKnockButton(), buildAddFriendButton()],
      ),
    );
  }

  Widget buildGroupKnockButton() {
    return ButtonWrapper(
      onPressed: () {
        // final uid = Get.find<UserService>().currentUser!.uid;
        // Get.find<StatusService>().create('5da55', {
        //   'statusType': StatusType.INVALID.index,
        //   'name': '',
        //   'comment': ''
        // }).then((value) => print('done'));
      },
      text: '그룹 노크',
      icon: const Icon(
        Icons.send,
        size: 15,
      ),
      options: ButtonWrapperOption(
        width: 140,
        height: 40,
        color: Get.theme.primaryColor,
        textStyle: Get.textTheme.labelMedium,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget buildAddFriendButton() {
    return IconButtonWrapper(
        borderColor: Colors.transparent,
        borderRadius: 30,
        borderWidth: 1,
        buttonSize: 45,
        icon: Icon(
          Icons.person_add,
          color: Get.theme.iconTheme.color,
          size: 30,
        ),
        onPressed: () => controller.addFriendIfResultExist());
  }
}
