import 'package:flutter/material.dart';

class Notification {
  String title;
  String? subTitle;
  IconData? icon;

  Notification({required this.title, this.subTitle, this.icon});
}
