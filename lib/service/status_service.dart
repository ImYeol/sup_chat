import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';

class StatusService extends GetxService {
  final databaseReference = FirebaseDatabase.instance.ref('status');

  StreamSubscription observeUserStatusRef(
      String uid, Function(DatabaseEvent) onData,
      {Function? onError, Function()? onDone, bool? cancerOnError}) {
    return databaseReference.child(uid).onValue.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancerOnError);
  }

  Future<void> create(String uid, Map<String, dynamic> data) {
    return databaseReference
        .child(uid)
        .set(data)
        .then((value) => print('data of $uid has been stored'))
        .catchError((error) => 'data store error : $error');
  }

  Future<Map<String, dynamic>?> read(String uid) async {
    final snapshot = await databaseReference.child(uid).get();
    if (snapshot.exists) {
      return snapshot.value as Map<String, dynamic>;
    } else {
      print('No data available.');
      return null;
    }
  }

  Future<void> update(String uid, Map<String, dynamic> data) {
    return databaseReference.child(uid).update({'description': 'CEO'});
  }

  Future<void> delete(String uid) {
    return databaseReference.child(uid).remove();
  }
}
