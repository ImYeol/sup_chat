enum MessageType { knock, friendRequest }

class MessageModel {
  String? fromName;
  MessageType? type;
  DateTime? createdAt;

  MessageModel({required this.fromName, required this.type, this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    fromName = json['from_name'];
    type = MessageType.values[json['msg_type']];
    createdAt = DateTime.parse(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['from_name'] = fromName;
    data['msg_type'] = type!.index;
    data['created_at'] = createdAt?.toString();
    return data;
  }

  String getTitle() {
    return '';
  }

  String getMessage() {
    return '';
  }

  @override
  int get hashCode => createdAt.hashCode;

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return other is MessageModel &&
        other.fromName == fromName &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  String toString() {
    return 'from_name: $fromName, msg_type: $type, createdAt: $createdAt';
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
