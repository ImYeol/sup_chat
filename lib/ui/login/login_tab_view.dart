import 'package:flutter/material.dart';
import 'package:sup_chat/component/button_wrapper.dart';

class LoginTabView extends StatelessWidget {
  LoginTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  Widget buildEmailAdressTextFormField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: TextFormField(
        //controller: emailAddressLoginController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Email Address',
          labelStyle: Theme.of(context).textTheme.labelSmall,
          hintText: 'Enter your email...',
          hintStyle: Theme.of(context).textTheme.labelSmall,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).iconTheme.color ??
                  Theme.of(context).colorScheme.surface,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).iconTheme.color ??
                  Theme.of(context).colorScheme.surface,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
        ),
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
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
