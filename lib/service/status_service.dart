import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sup_chat/model/user_status.dart';

class StatusService extends GetxService {
  final databaseReference = FirebaseDatabase.instance.ref('state');
  final userStatusMap = <String, UserStatus>{}.obs;
  final _subscriptionMap = <StreamSubscription>[];

  void onUserStatusChanged(DatabaseEvent event) {
    print(
        "onUserStatusChanged : ${event.snapshot.key} : ${event.snapshot.value}");
    final snapshot = (event.snapshot.value ?? {}) as dynamic;
    final status = UserStatus.fromJson(snapshot);
    final uid = event.snapshot.key;
    print("onStatusChanged key = ${event.snapshot.key}, status = $status");
    if (uid == null) return;
    userStatusMap[uid] = status;
  }

  void observeUserStatusRef(String uid) {
    try {
      final streamSubscription = databaseReference.child(uid).onValue.listen(
          onUserStatusChanged,
          onError: (error) =>
              print("observeUserStatusRef subscription onError $error"),
          cancelOnError: true);
      _subscriptionMap.add(streamSubscription);
    } catch (e) {
      print("observeUserStatusRef : $e");
    }
  }

  void unobserveUserStatusRef() {
    _subscriptionMap.map((subscription) => subscription.cancel());
    _subscriptionMap.clear();
  }

  Future<void> create(String uid, UserStatus status) {
    print("create : $status");
    return databaseReference
        .child(uid)
        .set(status.toJson())
        .then((value) => print('data of $uid has been stored'))
        .catchError((error) => 'data store error : $error');
  }

  Future<UserStatus> read(String uid) async {
    final snapshot = await databaseReference.child(uid).get();
    if (snapshot.exists) {
      print("read state - ${snapshot.value}");
      return UserStatus.fromJson(snapshot.value as dynamic);
    } else {
      print('No data available.');
      return UserStatus();
    }
  }

  Future<void> update(String uid, UserStatus status, {useCache = false}) async {
    if (useCache) {
      userStatusMap.update(
        uid,
        (value) => status,
        ifAbsent: () => status,
      );
    } else {
      databaseReference.child(uid).update(status.toJson());
    }
  }

  Future<void> delete(String uid) {
    return databaseReference.child(uid).remove();
  }

  void clear() {
    unobserveUserStatusRef();
    userStatusMap.clear();
  }
}
