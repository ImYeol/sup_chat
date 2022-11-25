import 'package:flutter/material.dart';

class IconButtonWrapper extends StatelessWidget {
  double buttonSize;
  Color? fillColor;
  Color borderColor;
  double borderWidth;
  double borderRadius;
  Icon icon;
  void Function()? onPressed;
  EdgeInsetsDirectional? padding;
  AlignmentGeometry? alignment;

  IconButtonWrapper(
      {Key? key,
      this.buttonSize = 60,
      this.fillColor,
      this.borderColor = Colors.transparent,
      this.borderWidth = 1,
      this.borderRadius = 30,
      this.onPressed,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          )),
      child: IconButton(onPressed: onPressed, icon: icon),
    );
  }
}
