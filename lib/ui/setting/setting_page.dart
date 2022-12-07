import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/constants/app_theme.dart';
import 'package:sup_chat/service/user_service.dart';

class SettingPage extends StatelessWidget {
  bool switchListTileValue1 = false;
  bool switchListTileValue2 = false;
  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Get.theme.iconTheme.color,
            size: 30,
          ),
          onPressed: () {
            print('IconButton pressed ...');
            Get.back();
          },
        ),
        title: Text(
          '설정',
          style: Get.textTheme.titleLarge,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: switchListTileValue1,
              onChanged: (newValue) async {
                // setState(() => switchListTileValue1 = newValue!);
              },
              title: Text(
                '푸쉬 알림 활성화',
                style: Get.textTheme.titleMedium,
              ),
              subtitle: Text(
                '푸쉬 알림을 활성화 합니다',
                style: Get.textTheme.bodySmall,
              ),
              activeColor: Get.theme.primaryColor,
              activeTrackColor: Color(0x8A4B39EF),
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
            ),
          ),
          SwitchListTile.adaptive(
            value: switchListTileValue2,
            onChanged: (newValue) async {
              // setState(() => switchListTileValue2 = newValue!);
              switchListTileValue2 = newValue;
              Get.changeTheme(
                  newValue ? AppDarkTheme.theme : AppLightTheme.theme);
            },
            title: Text(
              '다크모드',
              style: Get.textTheme.titleMedium,
            ),
            subtitle: Text(
              '다코모드를 활성화 합니다',
              style: Get.textTheme.bodySmall,
            ),
            activeColor: Color(0xFF4B39EF),
            activeTrackColor: Color(0xFF3B2DB6),
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: ButtonWrapper(
              onPressed: () => Get.find<UserService>().signOut(),
              text: '로그아웃',
              options: ButtonWrapperOption(
                width: 190,
                height: 50,
                color: Get.theme.primaryColor,
                textStyle: Get.textTheme.bodyLarge,
                elevation: 3,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
