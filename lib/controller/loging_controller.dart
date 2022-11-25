import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/service/user_service.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

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
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value == null) {
      return 'Please this field must be filled1';
    } else if (value.isEmpty) {
      return 'Please this field must be filled2';
    }
    return null;
  }

  String? confirmValidator(String? value) {
    if (value == null) {
      return 'Please this field must be filled1';
    } else if (value.isEmpty) {
      return 'Please this field must be filled2';
    } else if (!passwordController.text.contains(value)) {
      return "Not matched password";
    }
    return null;
  }

  void signUp() async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      print("after createUserWithEmailAndPassword");
      final firebaseUser = result.user;
      print("updateDisplayName");
      firebaseUser?.updateDisplayName(nameController.text.trim());
      print("create user");
      // TODO: remove getUser
      Get.find<UserService>()
          .getUser(firebaseUser?.uid ?? "")
          .then((user) => user.update({
                "email": emailController.text.trim(),
                "name": nameController.text.trim(),
              }));
    } catch (e) {
      Get.snackbar("About Account", "Account message",
          snackPosition: SnackPosition.BOTTOM,
          titleText:
              Text("Account creation failed", style: Get.textTheme.labelMedium),
          messageText: Text(e.toString(), style: Get.textTheme.labelSmall));
    }
  }

  void logIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (e) {
      Get.snackbar("About Login", "Login message",
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("Login failed", style: Get.textTheme.labelMedium),
          messageText: Text(e.toString(), style: Get.textTheme.labelSmall));
    }
  }

  void logOut() async {
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
    await _auth.signOut();
  }
}
