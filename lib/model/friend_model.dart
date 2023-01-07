import 'package:get/get.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';

enum FriendState {
  invalid,
  request,
  pending,
  done,
}

class FriendModel {
  late String uid;
  late String name;
  late FriendState state;
  final status = UserStatus().obs;

  FriendModel(
      {this.uid = '', this.name = '', this.state = FriendState.invalid});

  FriendModel.fromJson(this.uid, Map<String, dynamic> data) {
    name = data['name'] ?? '';
    state = FriendState.values[data['state'] ?? FriendState.invalid];
  }

  FriendModel.fromUserModel(UserModel user) {
    uid = user.uid;
    name = user.name;
    state = FriendState.invalid;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['state'] = state.index;
    return data;
  }

  @override
  bool operator ==(covariant FriendModel other) => uid == other.uid;

  @override
  String toString() {
    // TODO: implement toString
    return "uid = $uid, name = $name, state = $state";
  }
}
