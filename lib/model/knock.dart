class Knock {
  String fromUid;
  String toUid;
  DateTime updatedAt;

  Knock({required this.fromUid, required this.toUid, required this.updatedAt});

  factory Knock.fromJson(Map<String, dynamic> json) {
    return Knock(
        fromUid: json['fromUid'],
        toUid: json['toUid'],
        updatedAt: json['updatedAt']);
  }

  Map<String, dynamic> toJson() => {'fromUid': fromUid, 'updatedAt': updatedAt};

  @override
  String toString() {
    return 'fromUid=$fromUid, toUid=$toUid, updatedAt=$updatedAt';
  }
}
