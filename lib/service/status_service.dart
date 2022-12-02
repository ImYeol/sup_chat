import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';

class StatusService extends GetxService {
  final databaseReference = FirebaseDatabase.instance.ref('state');
  final box = GetStorage('status');

  Future<void> initBox() async {
    await GetStorage.init('status');
  }

  @override
  void onInit() {
    initBox();
    super.onInit();
  }

  StreamSubscription observeUserStatusRef(
      String uid, Function(DatabaseEvent) onData,
      {Function? onError, Function()? onDone, bool? cancerOnError}) {
    return databaseReference.child(uid).onValue.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancerOnError);
  }

  Future<void> create(String uid, UserStatus status) {
    print("create : $status");
    box.write(uid, status.toJson());
    return databaseReference
        .child(uid)
        .set(status.toJson())
        .then((value) => print('data of $uid has been stored'))
        .catchError((error) => 'data store error : $error');
  }

  Future<UserStatus?> read(String uid) async {
    final statusMap = box.read(uid);
    if (statusMap != null) return UserStatus.fromJson(statusMap);

    final snapshot = await databaseReference.child(uid).get();
    if (snapshot.exists) {
      return UserStatus.fromJson(snapshot.value as dynamic);
    } else {
      print('No data available.');
      return null;
    }
  }

  Future<void> update(String uid, UserStatus status) {
    box.write(uid, status.toJson());
    return databaseReference.child(uid).update(status.toJson());
  }

  Future<void> delete(String uid) {
    box.remove(uid);
    return databaseReference.child(uid).remove();
  }

  @override
  void onClose() {
    box.save();
    super.onClose();
  }
}
