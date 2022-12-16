import 'package:flutter/material.dart';

class Notification {
  final String title;
  final String subTitle;
  IconData? icon;

  Notification(
      {required this.title,
      required this.subTitle,
      this.icon = Icons.notifications});
}
