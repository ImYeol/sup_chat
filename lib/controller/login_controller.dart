import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final loginFormKey = GlobalKey<FormState>();
  // final emailController = TextEditingController();
  // final nameController = TextEditingController();
  // final passwordController = TextEditingController();

  final signinFormKey = GlobalKey<FormState>();
  // final emailController = TextEditingController();
  // final nameController = TextEditingController();
  // final passwordController = TextEditingController();
  // final passwordConfirmController = TextEditingController();

  String? email;
  String? name;
  String? password;

  @override
  void onInit() {
    print("LoginController onInit");
    super.onInit();
  }

  @override
  void onReady() {
    print("LoginController onReady");
    super.onReady();
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    // passwordConfirmController.dispose();
    super.onClose();
  }

  String? emailValidator(String? value) {
    if (value != null && GetUtils.isEmail(value))
      return null;
    else if (value == null)
      return '이메일을 입력해주세요';
    else
      return '잘못된 이메일 형식입니다';
  }

  String? nameValidator(String? value) {
    if (value != null &&
        GetUtils.isUsername(value) &&
        GetUtils.isLengthLessThan(value, 12))
      return null;
    else if (value == null)
      return '이름을 입력해주세요';
    else
      return '잘못된 이름 형식입니다';
  }

  String? passwordValidator(String? value) {
    if (value != null && GetUtils.isPassport(value))
      return null;
    else if (value == null)
      return '암호를 입력해주세요';
    else
      return '잘못된 암호 형식입니다';
  }

  String? confirmValidator(String? value) {
    if (value != null && value == password?.substring(0, value.length))
      return null;
    else if (value == null)
      return '이메일을 입력해주세요';
    else
      return '암호가 일치하지 않습니다';
  }

  void signUp() async {
    if (signinFormKey.currentState!.validate()) {
      signinFormKey.currentState!.save();
    } else {
      print('invalid trying signup');
      return;
    }

    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email!.trim(), password: password!.trim());
      print("after createUserWithEmailAndPassword");
      final firebaseUser = result.user;
      print("updateDisplayName");
      firebaseUser?.updateDisplayName(name!.trim()).then((_) {
        final status = UserStatus(name: name, statusType: StatusType.INVALID);
        status.create(firebaseUser.uid);
        print('create user status');
      });
    } catch (e) {
      Get.snackbar("About Account", "Account message",
          snackPosition: SnackPosition.BOTTOM,
          titleText:
              Text("Account creation failed", style: Get.textTheme.labelMedium),
          messageText: Text(e.toString(), style: Get.textTheme.labelSmall));
      print('signup error: ${e.toString()}');
    }
  }

  void logIn() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
    } else {
      print('invalid trying login');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: email!.trim(), password: password!.trim());
    } catch (e) {
      Get.snackbar("About Login", "Login message",
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("Login failed", style: Get.textTheme.labelMedium),
          messageText: Text(e.toString(), style: Get.textTheme.labelSmall));
    }
  }

  void logOut() async {
    // emailController.clear();
    // passwordController.clear();
    // passwordConfirmController.clear();
    await _auth.signOut();
  }
}
