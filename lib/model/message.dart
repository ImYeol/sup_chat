enum MessageType { knock, friendRequest }

class MessageModel {
  String? fromName;
  MessageType? type;

  MessageModel({required this.fromName, required this.type});

  MessageModel.fromJson(Map<String, dynamic> json) {
    fromName = json['from_name'];
    type = MessageType.values[json['msg_type']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['from_name'] = fromName;
    data['msg_type'] = type!.index;
    return data;
  }

  String getTitle() {
    return '';
  }

  String getMessage() {
    return '';
  }
}

class KnockMessageModel extends MessageModel {
  KnockMessageModel({required super.fromName, super.type = MessageType.knock});
  KnockMessageModel.fromJson(super.json) : super.fromJson();

  @override
  String getMessage() {
    return 'knock knock';
  }

  @override
  String getTitle() {
    return '$fromName님께서 노크 하였습니다.';
  }
}

class FriendRequestMessageModel extends MessageModel {
  FriendRequestMessageModel(
      {required super.fromName, super.type = MessageType.knock});
  FriendRequestMessageModel.fromJson(super.json) : super.fromJson();

  @override
  String getMessage() {
    return '친구요청';
  }

  @override
  String getTitle() {
    return '$fromName님께서 친구 요청 하였습니다.';
  }
}
