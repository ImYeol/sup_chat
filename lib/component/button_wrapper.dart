import 'package:flutter/material.dart';

class ButtonWrapper extends StatelessWidget {
  ButtonWrapperOption options;
  Color? fillColor;
  Icon? icon;
  String text;
  void Function()? onPressed;
  EdgeInsetsDirectional? padding;
  AlignmentGeometry? alignment;

  ButtonWrapper(
      {Key? key,
      this.onPressed,
      this.fillColor,
      this.text = '',
      this.icon,
      required this.options,
      this.padding,
      this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: options.borderRadius, side: options.borderSide),
            backgroundColor: options.color,
            textStyle: options.textStyle,
            elevation: options.elevation ?? 0),
        child: Container(
          width: options.width,
          height: options.height,
          padding: padding,
          alignment: alignment,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(child: icon), Text(text)],
          ),
        ));
  }
}

class ButtonWrapperOption {
  double width;
  double height;
  Color color;
  TextStyle? textStyle;
  TextAlign? textAlign;
  Color? borderColor;
  BorderSide borderSide;
  double? borderWidth;
  BorderRadius borderRadius;
  double? elevation;

  ButtonWrapperOption(
      {this.width = 50,
      this.height = 50,
      this.color = Colors.purple,
      this.textStyle,
      this.borderSide = BorderSide.none,
      this.borderRadius = BorderRadius.zero,
      this.borderWidth,
      this.borderColor,
      this.elevation});
}
