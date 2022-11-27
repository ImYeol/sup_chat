import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/controller/login_controller.dart';
import 'package:sup_chat/ui/login/login_outlined_form_field.dart';

class RegisterTabView extends StatelessWidget {
  final controller = Get.find<LoginController>();

  RegisterTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          key: controller.signinFormKey,
          children: [
            LoginOutlinedFormField(labelText: 'Email Address', hintText: '이메일을 입력해주세요', validator: controller.emailValidator, onSaved: (value) => controller.email = value),
            LoginOutlinedFormField(labelText: 'Name', hintText: '닉네임을 입력해주세요', validator: controller.nameValidator, onSaved: (value) => controller.name = value,),
            LoginOutlinedFormField(labelText: 'Password', hintText: '암호를 입력해주세요', validator: controller.passwordValidator, onSaved: (value) => controller.password = value,),
            LoginOutlinedFormField(labelText: 'Confirm Password', hintText: '암호를 입력해주세요', validator: controller.confirmValidator),
            buildSignInButton(context),
          ],
        ),
      )
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
      child: ButtonWrapper(
        onPressed: () => controller.signUp(),
        text: 'Login',
        options: ButtonWrapperOption(
          width: 230,
          height: 50,
          color: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.titleMedium,
          elevation: 3,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
