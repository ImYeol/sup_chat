import 'package:flutter/material.dart';
import 'package:sup_chat/component/user_status_icon.dart';

class UserStatusCard extends StatelessWidget {
  Color? backgroundColor;
  double width;
  double height;
  double elevation;
  UserStatusIcon icon;
  String? displayText;
  TextStyle? displayTextStyle;
  String statusText;
  TextStyle? statusTextStyle;
  String? labelText;
  TextStyle? labelTextStyle;
  void Function()? onTap;
  void Function()? onDoubleTap;
  void Function()? onLongPress;

  UserStatusCard(
      {Key? key,
      this.backgroundColor,
      this.width = 150,
      this.height = 150,
      this.elevation = 1,
      required this.icon,
      this.displayText,
      this.displayTextStyle,
      required this.statusText,
      this.statusTextStyle,
      this.labelText,
      this.labelTextStyle,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      displayText ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              icon,
              Text(
                statusText,
                style:
                    statusTextStyle ?? Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    labelText ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
