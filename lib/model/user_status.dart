import 'package:get/get.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/service/status_service.dart';

class UserStatus {
  String? name;
  StatusType? statusType;
  String? comment;

  UserStatus({this.name, this.statusType, this.comment});

  Future<void> create(String uid) async {
    return Get.find<StatusService>().create(uid, toJson());
  }

  Future<void> update(String uid) async {
    return Get.find<StatusService>().update(uid, toJson());
  }

  Future<void> delete(String uid) async {
    return Get.find<StatusService>().delete(uid);
  }

  void copyWith(UserStatus status) {
    name = status.name;
    statusType = status.statusType;
    comment = status.comment;
  }

  Map<String, dynamic> toJson() => {
        'name': name ?? '',
        'statusType': statusType ?? StatusType.INVALID,
        'comment': comment ?? '',
      };

  UserStatus.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    statusType = json['statusType'] ?? StatusType.INVALID;
    comment = json['comment'] ?? '';
  }

  @override
  String toString() {
    return "name = $name, statusType = $statusType comment = $comment";
  }
}
