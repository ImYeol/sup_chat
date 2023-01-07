import 'dart:io';

class FCMTokenModel {
  String? token;
  String? deviceType;

  FCMTokenModel({this.token = '', this.deviceType = 'android'});

  FCMTokenModel.fromJson(Map<String, dynamic> json) {
    token = json['fcm_token'] ?? '';
    deviceType = json['device_type'] ?? Platform.operatingSystem;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcm_token'] = token;
    data['device_type'] = deviceType;
    return data;
  }
}
