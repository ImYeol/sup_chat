import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/fcm_token.dart';
import 'package:sup_chat/service/user_service.dart';

class UserModel {
  String uid = '';
  String name = '';
  bool exists = false;
  Timestamp? updatedAt;
  Timestamp? createdAt;

  UserModel({
    this.uid = '',
    this.name = '',
    this.exists = false,
    this.updatedAt,
    this.createdAt,
  });

  Future<void> update(Map<String, dynamic> data) {
    return Get.find<UserService>().update(data);
  }

  void setProperties(dynamic data, String uid) {
    this.uid = uid;
    print("setProperties : uid(${this.uid}");
    if (data == null) return;

    name = data['name'] ?? '';
    print("name = $name");

    /// Some timestamp data (like date from Typesense) is int.
    createdAt = data['createdAt'] is int
        ? Timestamp(data['createdAt'], 0)
        : data['createdAt'];
    updatedAt = data['updatedAt'] is int
        ? Timestamp(data['updatedAt'], 0)
        : data['updatedAt'];
    print("createdAt = $createdAt, updatedAt = $updatedAt");
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    setProperties(snapshot.data(), snapshot.id);
  }

  @override
  String toString() {
    return "uid = $uid, name = $name, updatedAt = $updatedAt createdAt = $createdAt";
  }

  @override
  bool operator ==(covariant UserModel other) => uid == other.uid;

  @override
  int get hashCode => name.hashCode;
}
