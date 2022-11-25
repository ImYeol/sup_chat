import 'package:flutter/material.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/component/user_status_card.dart';
import 'package:sup_chat/component/user_status_icon.dart';
import 'package:sup_chat/model/user_model.dart';

class FriendSearchResult extends StatelessWidget {
  UserModel? searchResult;
  FriendSearchResult({Key? key, this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                children: [
                  UserStatusCard(
                      icon: UserStatusIcon(
                        iconData: Icons.person,
                        iconSize: 32,
                      ),
                      statusText: searchResult?.name ?? ''),
                  buildAddButton(context),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildAddButton(BuildContext context) {
    return ButtonWrapper(
      onPressed: () {
        print('Button pressed ...');
      },
      text: '친구추가',
      icon: const Icon(
        Icons.add,
        size: 15,
      ),
      options: ButtonWrapperOption(
        width: 140,
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
