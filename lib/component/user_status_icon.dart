import 'package:flutter/material.dart';

class UserStatusIcon extends StatelessWidget {
  double width;
  double height;
  Color? iconColor;
  IconData iconData;
  double? iconSize;
  Color? backgroundColor;

  UserStatusIcon({
    Key? key,
    this.width = 48,
    this.height = 48,
    this.iconColor,
    required this.iconData,
    this.iconSize,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        //Icons.self_improvement_outlined,
        iconData,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: iconSize ?? 32,
      ),
    );
  }
}
