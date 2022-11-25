import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  IconData? iconData;
  Color? backgroundColor;
  Color? iconColor;
  BorderRadius? borderRadius;
  Alignment? alignment;
  double? width;
  double? height;
  double? iconSize;

  NotificationIcon(
      {Key? key,
      this.iconData,
      this.backgroundColor,
      this.iconColor,
      this.borderRadius,
      this.alignment,
      this.width,
      this.height,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      alignment: alignment,
      child: Icon(
        iconData,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: iconSize ?? 35,
      ),
    );
  }
}
