import 'package:flutter/material.dart';

class LoginOutlinedFormField extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const LoginOutlinedFormField({Key? key, this.padding, required this.labelText, required this.hintText, this.validator, this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding?? EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: TextFormField(
        //controller: emailAddressLoginController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          hintText: hintText,
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
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}