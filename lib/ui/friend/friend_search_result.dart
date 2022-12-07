import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/component/user_status_card.dart';
import 'package:sup_chat/component/user_status_icon.dart';
import 'package:sup_chat/controller/add_friend_controller.dart';
import 'package:sup_chat/model/user_model.dart';

class FriendSearchResult extends StatelessWidget {
  final UserModel searchResult;
  const FriendSearchResult({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchResult.createdAt == null) return const NoResult();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            thickness: 1,
            color: Theme.of(context).iconTheme.color,
          ),
          searchResult.name.isNotEmpty
              ? buildUserStatusCard(context)
              : Container()
        ],
      ),
    );
  }

  Widget buildUserStatusCard(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
        child: Column(
          children: [
            UserStatusCard(
                width: 150,
                height: 120,
                icon: UserStatusIcon(
                  iconData: Icons.person,
                  iconSize: 32,
                ),
                statusText: searchResult.name),
            const SizedBox(
              height: 10,
            ),
            buildAddButton(context),
          ],
        ));
  }

  Widget buildAddButton(BuildContext context) {
    return ButtonWrapper(
      onPressed: () => Get.find<AddFriendController>().addFriend(searchResult),
      text: '친구추가',
      icon: const Icon(
        Icons.add,
        size: 15,
      ),
      options: ButtonWrapperOption(
        width: 100,
        height: 40,
        color: Theme.of(context).primaryColor,
        textStyle: Theme.of(context).textTheme.labelMedium,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class NoResult extends StatelessWidget {
  const NoResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '검색 결과가 없습니다',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
