import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/icon_button_wrapper.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/controller/home_controller.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/ui/home/friend_tab_view.dart';
import 'package:sup_chat/ui/home/notification_tab_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildMenuBar(),
            Obx(() => buildTtitle(controller.currentUserStatus)),
            Obx(() => buildStatusView(controller.currentUserStatus)),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        labelStyle: Get.textTheme.bodyMedium,
                        labelColor: Get.theme.colorScheme.outline,
                        unselectedLabelColor: const Color(0xFF8B97A2),
                        unselectedLabelStyle: Get.textTheme.bodyMedium,
                        indicatorColor: Get.theme.colorScheme.tertiary,
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(
                            text: '친구',
                          ),
                          Tab(
                            text: '알림',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            FriendTabView(),
                            NotificationTabView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButtonWrapper(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.settings,
              color: Get.theme.iconTheme.color,
              size: 30,
            ),
            onPressed: () async {
              Get.toNamed(AppRoute.SETTING);
              // onSettingBtnTapped
              // await Navigator.push(
              //   context,
              //   PageTransition(
              //     type: PageTransitionType.leftToRight,
              //     duration: Duration(milliseconds: 300),
              //     reverseDuration: Duration(milliseconds: 300),
              //     child: SettingPageWidget(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTtitle(UserStatus userStatus) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userStatus.name ?? 'Login Error',
            style: Get.textTheme.displayLarge?.copyWith(
              fontFamily: 'Outfit',
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusView(UserStatus userStatus) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 45, 0, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70),
        ),
        child: Container(
          width: 320,
          height: 200,
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(70),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Get.theme.colorScheme.outline,
              width: 0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButtonWrapper(
                  borderColor: Colors.transparent,
                  borderRadius: 50,
                  borderWidth: 1,
                  buttonSize: 80,
                  fillColor: Get.theme.colorScheme.tertiary,
                  icon: Icon(
                    Icons.directions_bike,
                    color: Get.theme.iconTheme.color,
                    size: 50,
                  ),
                  onPressed: () async {
                    // await showModalBottomSheet(
                    //   isScrollControlled: true,
                    //   backgroundColor: Colors.transparent,
                    //   barrierColor: Get.theme.backgroundColor,
                    //   context: context,
                    //   builder: (context) {
                    //     return Padding(
                    //       padding: MediaQuery.of(context).viewInsets,
                    //       child: const ChooseStatusSheet(),
                    //     );
                    //   },
                    // );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mapStatusTypeToString[
                              userStatus.statusType ?? StatusType.INVALID] ??
                          '잘못된상태',
                      style: Get.textTheme.headlineMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userStatus.comment ?? '상태를 입력해주세요',
                        style: Get.textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
