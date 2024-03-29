import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/controller/login_controller.dart';
import 'package:sup_chat/ui/login/login_tab_view.dart';
import 'package:sup_chat/ui/login/register_tabl_view.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: buildContents(),
      ),
    );
  }

  Widget buildContents() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        buildTitle(),
        buildTabBar(),
      ],
    );
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 70),
          child: Text('Bbeep',
              style: Get.textTheme.titleMedium?.copyWith(fontSize: 58)),
        )
      ],
    );
  }

  Widget buildTabBar() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Get.theme.colorScheme.tertiary,
              labelStyle: Get.textTheme.titleSmall,
              unselectedLabelColor: const Color(0xFF8B97A2),
              unselectedLabelStyle: Get.textTheme.titleSmall,
              indicatorColor: Get.theme.colorScheme.tertiary,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  text: '로그인',
                ),
                Tab(
                  text: '회원가입',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [LoginTabView(), RegisterTabView()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
