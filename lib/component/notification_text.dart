import 'package:flutter/material.dart';

class NotificationText extends StatelessWidget {
  String title;
  String? subTitle;
  EdgeInsetsGeometry? padding;
  TextStyle? titleStyle;
  TextStyle? subTitleStyle;

  NotificationText(
      {Key? key,
      required this.title,
      this.subTitle,
      this.padding,
      this.titleStyle,
      this.subTitleStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ?? Theme.of(context).textTheme.labelLarge,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
            child: Text(
              subTitle ?? '',
              style: subTitleStyle ?? Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
