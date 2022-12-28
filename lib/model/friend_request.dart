import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  static const int invalid = 0;
  static const int pending = 1;
  static const int done = 2;

  String? name;
  Timestamp? createdAt;

  FriendRequest({this.name, this.createdAt});

  FriendRequest.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    createdAt = data['createdAt'] is int
        ? Timestamp(data['createdAt'], 0)
        : data['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['createdAt'] = createdAt;
    return data;
  }
}
