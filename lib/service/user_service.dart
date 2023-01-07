import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/friend_model.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/service/message_service.dart';
import 'package:sup_chat/service/status_service.dart';

class UserService extends GetxService {
  final currentUser = UserModel().obs;
  final friends = <FriendModel>[].obs;
  StreamSubscription? authDocumentSubscription;
  StreamSubscription? userDocumentSubscription;
  StreamSubscription? friendsDocumentSubscription;

  CollectionReference get col => FirebaseFirestore.instance.collection('users');
  DocumentReference get doc => col.doc(FirebaseAuth.instance.currentUser?.uid);

  CollectionReference get friendsCol => doc.collection('friends');

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  void init() {
    authDocumentSubscription =
        FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        print("authStateChanges - firebaseUser is null");
        unobserveUserDoc();
        unobserveFriendCollection();
        friends.clear();
        // if (Get.currentRoute != AppRoute.LOGIN) {
        //   Get.offAllNamed(AppRoute.LOGIN);
        // }
      } else {
        print("authStateChanges - user is ${firebaseUser.displayName}");
        observeUserDoc();
        observeFriendsCollection();
        //loadFriends();
      }
    });
  }

  @override
  void onInit() {
    print("UserService onInit");
    init();
    super.onInit();
  }

  @override
  void onClose() {
    print("UserService onClose");
    authDocumentSubscription?.cancel();
    super.onClose();
  }

  Future<UserModel> getUser(
    String uid, {
    bool cache = true,
  }) async {
    final snapshot = await col.doc(uid).get();
    return UserModel.fromSnapshot(snapshot);
  }

  Future<FriendModel?> searchFriendByName(String name,
      {useCache = true}) async {
    if (useCache) {
      return friends[friends.indexWhere((element) => element.name == name)];
    }
    final snapshot = await col.where('name', isEqualTo: name).get();
    final user = snapshot.docs.isNotEmpty
        ? snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).first
        : UserModel();
    print("getUserByName : $user");
    return FriendModel.fromUserModel(user);
  }

  Future<void> sendFriendRequest(String toUid, String toName) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(
        col
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('friends')
            .doc(toUid),
        FriendModel(uid: toUid, name: toName, state: FriendState.pending)
            .toJson());
    batch.set(
        col
            .doc(toUid)
            .collection('friends')
            .doc(FirebaseAuth.instance.currentUser?.uid),
        FriendModel(
                uid: currentUser.value.uid,
                name: currentUser.value.name,
                state: FriendState.request)
            .toJson());
    return batch.commit().then((value) => null);
  }

  Future<void> acceptFriendReqeust(String toUid) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(
        col
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('friends')
            .doc(FirebaseAuth.instance.currentUser?.uid),
        {'state': FriendState.done.index});
    batch.update(col.doc(toUid).collection('friends').doc(toUid),
        {'state': FriendState.done.index});
    return batch.commit();
  }

  Future<void> deleteFriend(String toUid) async {
    if (toUid == currentUser.value.uid) {
      print("friend is current user");
      return;
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.delete(col
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser?.uid));
    batch.delete(col.doc(toUid).collection('friends').doc(toUid));
    return batch.commit();
  }

  void onFriendAdded(FriendModel friend) {
    print("onFriendAdded: $friend");
    if (friend.state == FriendState.done) {
      MessageService.instance.observeFcmTokenState(friend.uid);
      Get.find<StatusService>().observeUserStatusRef(friend.uid);
    }
    friends.add(friend);
  }

  void onFriendUpdated(FriendModel friend) {
    print("onFriendUpdated: $friend");
    final position = friends.indexOf(friend);
    if (position != -1) {
      if (friends[position].state != FriendState.done &&
          friend.state == FriendState.done) {
        MessageService.instance.observeFcmTokenState(friend.uid);
        Get.find<StatusService>().observeUserStatusRef(friend.uid);
      }
      friends[position] = friend;
    }
  }

  void onFriendDeleted(FriendModel friend) {
    print("onFriendDeleted: $friend");
    if (friend.state == FriendState.done) {
      MessageService.instance.unobserveFcmTokenState(friend.uid);
      Get.find<StatusService>().unobserveUserStatusRef(friend.uid);
    }
    friends.remove(friend);
  }

  void observeFriendsCollection() {
    print("observeFriendsCollection");
    friendsDocumentSubscription?.cancel();
    friendsDocumentSubscription = friendsCol.snapshots().listen((event) {
      print("observeFriendsCollection listen ${event.docChanges.length}");
      for (var change in event.docChanges) {
        final friend =
            FriendModel.fromJson(change.doc.id, change.doc.data() as dynamic);
        switch (change.type) {
          case DocumentChangeType.added:
            onFriendAdded(friend);
            break;
          case DocumentChangeType.modified:
            onFriendUpdated(friend);
            break;
          case DocumentChangeType.removed:
            onFriendDeleted(friend);
            break;
        }
      }
    });
  }

  void unobserveFriendCollection() {
    friendsDocumentSubscription?.cancel();
    friendsDocumentSubscription = null;
  }

  void observeUserDoc() {
    print("observeUserDoc");
    userDocumentSubscription?.cancel();
    userDocumentSubscription =
        doc.snapshots().listen((DocumentSnapshot snapshot) async {
      if (snapshot.exists == false) {
        // log('---> User document not exits in observeUserDoc.');
        print('---> User document not exits in observeUserDoc');
        return;
      }
      currentUser.value = UserModel.fromSnapshot(snapshot);
      // log('----> observeUserDoc and update event with; $user');
      //userChange.add(user);
      print('----> observeUserDoc and update event with; $currentUser');
    });
  }

  /// 로그아웃을 할 때 호출되며, 사용자 모델(user)을 초기화하고, listening 해제하고, 이벤트를 날린다.
  void unobserveUserDoc() {
    userDocumentSubscription?.cancel();
    currentUser.value = UserModel();
    //userChange.add(user);
  }

  // 문서가 존재하지 않으면 생성을 한다.
  Future<void> update(Map<String, dynamic> data) {
    return doc.set({
      ...data,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  bool isLoggedIn() {
    return currentUser.value.uid != '';
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
