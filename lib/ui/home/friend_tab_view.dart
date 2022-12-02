import 'package:flutter/material.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/component/icon_button_wrapper.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/user_status_card.dart';
import 'package:sup_chat/component/user_status_icon.dart';
import 'package:sup_chat/controller/home_controller.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class FriendTabView extends StatelessWidget {
  final controller = Get.find<HomeController>();

  FriendTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: buildFriendListView(),
        ),
        buildBottomMenu()
      ],
    );
  }

  Widget buildFriendListView() {
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
          itemCount: controller.friends.length,
          itemBuilder: ((context, index) => InkWell(
                onDoubleTap: () =>
                    controller.sendKnock(controller.friends[index]),
                onTap: () => controller.confirmFriendStatus(),
                onLongPress: () => controller.selectFriendsForGroupKnock(),
                child: UserStatusCard(
                  icon: UserStatusIcon(iconData: Icons.directions_bike_rounded),
                  statusText: mapStatusTypeToString[controller
                          .userStatusMap?[controller.friends[index].name]
                          ?.statusType] ??
                      '',
                ),
              ))),
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
      onPressed: () {
        print('IconButton pressed ...');
      },
    );
  }
}
