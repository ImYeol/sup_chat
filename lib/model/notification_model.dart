import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String subTitle;
  IconData? icon;
  final DateTime createdAt;

  NotificationModel(
      {required this.title,
      required this.subTitle,
      this.icon = Icons.notifications,
      required this.createdAt});

  @override
  String toString() {
    return 'title: $title, createdAt: $createdAt';
  }
}
