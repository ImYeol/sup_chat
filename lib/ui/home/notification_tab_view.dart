import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/notification_card.dart';
import 'package:sup_chat/component/notification_icon.dart';
import 'package:sup_chat/component/notification_text.dart';
import 'package:sup_chat/controller/home_controller.dart';

class NotificationTabView extends StatelessWidget {
  final controller = Get.find<HomeController>();

  NotificationTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = controller.notifications;
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: Obx(() => ListView.builder(
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(notifications[index].createdAt.toString()),
                background: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                onDismissed: (direction) =>
                    controller.onMessageDeleted(notifications[index]),
                child: NotificationCard(
                  text: NotificationText(
                      title: notifications[index].title,
                      subTitle: notifications[index].subTitle),
                  icon: NotificationIcon(
                    iconData: notifications[index].icon,
                  ),
                  createdAt: notifications[index].createdAt,
                ),
              ),
            )));
  }
}
