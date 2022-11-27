import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/controller/login_controller.dart';
import 'package:sup_chat/ui/login/login_outlined_form_field.dart';

class LoginTabView extends StatelessWidget {
  final controller = Get.find<LoginController>();
  LoginTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          key: controller.loginFormKey,
          children: [
            LoginOutlinedFormField(labelText: 'Email Address', hintText: '이메일을 입력해주세요', validator: controller.emailValidator, onSaved: (value) => controller.email = value),
            LoginOutlinedFormField(labelText: 'Password', hintText: '암호를 입력해주세요', validator: controller.passwordValidator, onSaved: (value) => controller.password = value,),
            buildLoginButton(context),
            buildForgotPasswordButton(context)
          ],
        ),
      )
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
      child: ButtonWrapper(
        onPressed: () => controller.logIn(),
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

  Widget buildForgotPasswordButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
      child: ButtonWrapper(
        onPressed: () async {
          // final user = await signInWithEmail(
          //   context,
          //   emailAddressLoginController!.text,
          //   passwordLoginController!.text,
          // );
          // if (user == null) {
          //   return;
          // }
          // await Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePageWidget(),
          //   ),
          //   (r) => false,
          // );
        },
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
