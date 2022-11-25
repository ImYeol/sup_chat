import 'package:flutter/material.dart';
import 'package:sup_chat/component/notification_icon.dart';
import 'package:sup_chat/component/notification_text.dart';

class NotificationCard extends StatelessWidget {
  double? elevation;
  Color? backgroundColor;
  BorderRadius? borderRadius;
  Border? border;
  NotificationIcon? icon;
  NotificationText text;

  NotificationCard(
      {Key? key,
      this.elevation,
      this.backgroundColor,
      this.borderRadius,
      this.icon,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation ?? 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: border ??
              Border.all(
                color: const Color(0x00FFFFFF),
                width: 0,
              ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              icon ?? Container(),
              Expanded(
                child: text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
