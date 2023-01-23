import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/service/user_service.dart';

class AuthGuard extends GetMiddleware {
  final userService = Get.find<UserService>();

  @override
  RouteSettings? redirect(String? route) {
    print("AuthGuard : login state = ${userService.isLoggedIn()}");
    return userService.isLoggedIn()
        ? null
        : const RouteSettings(name: AppRoute.LOGIN);
  }
}
