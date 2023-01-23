import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sup_chat/model/knock.dart';

class KnockService extends GetxService {
  final databaseReference = FirebaseDatabase.instance.ref('knock');
  final box = GetStorage('knock');
  late StreamSubscription<User?> _userAuthSubscription;
  late StreamSubscription<DatabaseEvent> _knockAddedSubscription;
  late StreamSubscription<DatabaseEvent> _knockChangedSubscription;

  Future<void> initBox() async {
    await GetStorage.init('knock');
  }

  void subscribeRemoteDataChanged() {
    _userAuthSubscription =
        FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        observeKnockRef(firebaseUser.uid);
      }
    });
  }

  @override
  void onInit() {
    initBox();
    subscribeRemoteDataChanged();
    super.onInit();
  }

  void onKnockAdded(DatabaseEvent event) {
    final snapshot = event.snapshot.val as dynamic;
    final knock = Knock.fromJson(snapshot);
    print("onKnockAdded fromUid=${knock.fromUid}, knock=$snapshot");
    box.write(knock.fromUid, snapshot);
  }

  void onKnockChanged(DatabaseEvent event) {
    final snapshot = event.snapshot.val as dynamic;
    final knock = Knock.fromJson(snapshot);
    print("onKnockChanged fromUid=${knock.fromUid}, knock=$snapshot");
    box.write(knock.fromUid, snapshot);
  }

  void observeKnockRef(String uid,
      {Function? onError, Function()? onDone, bool? cancerOnError}) {
    _knockAddedSubscription =
        databaseReference.child(uid).onChildAdded.listen(onKnockAdded);
    _knockChangedSubscription =
        databaseReference.child(uid).onChildChanged.listen(onKnockChanged);
  }

  Future<void> send(Knock knock) {
    print("create : $knock");
    return databaseReference
        .child(knock.toUid)
        .child(knock.fromUid)
        .set(knock.toJson())
        .then((value) => print('data of knock($knock) has been stored'))
        .catchError((error) => 'data store error : $error');
  }

  Future<Knock?> read(String toUid, String fromUid) async {
    final snapshot = await databaseReference.child(toUid).child(fromUid).get();
    if (snapshot.exists) {
      return Knock.fromJson(snapshot.value as dynamic);
    } else {
      print('No data available.');
      return null;
    }
  }

  Future<void> delete(String toUid, String fromUid) {
    return databaseReference.child(toUid).child(fromUid).remove();
  }

  @override
  void onClose() {
    box.save();
    _userAuthSubscription.cancel();
    _knockAddedSubscription.cancel();
    _knockChangedSubscription.cancel();
    super.onClose();
  }
}
