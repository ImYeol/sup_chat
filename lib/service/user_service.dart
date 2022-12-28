import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sup_chat/model/friend_request.dart';
import 'package:sup_chat/model/user_model.dart';

class UserService extends GetxService {
  final currentUser = UserModel().obs;
  final friends = <UserModel>[].obs;
  StreamSubscription? authDocumentSubscription;
  StreamSubscription? userDocumentSubscription;
  StreamSubscription? friendsDocumentSubscription;
  StreamSubscription? requestsDocumentSubscription;

  CollectionReference get col => FirebaseFirestore.instance.collection('users');
  //CollectionReference get friendCol => FirebaseFirestore.instance.collection('friends');
  DocumentReference get doc => col.doc(FirebaseAuth.instance.currentUser?.uid);
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get friendsCol => doc.collection('friends');
  CollectionReference get requestsCol => doc.collection('requests');

  void init() {
    authDocumentSubscription =
        FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        print("authStateChanges - firebaseUser is null");
        unobserveUserDoc();
        //friends.clear();
        // if (Get.currentRoute != AppRoute.LOGIN) {
        //   Get.offAllNamed(AppRoute.LOGIN);
        // }
      } else {
        print("authStateChanges - user is ${firebaseUser.displayName}");
        observeUserDoc();
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
    super.onClose();
  }

  Future<UserModel> getUser(
    String uid, {
    bool cache = true,
  }) async {
    final snapshot = await col.doc(uid).get();
    return UserModel.fromSnapshot(snapshot);
  }

  Future<UserModel> getUserByName(String name, {useCache = true}) async {
    if (useCache) {
      return friends.where((friend) => friend.name == name).first;
    }
    final snapshot = await col.where('name', isEqualTo: name).get();
    final user = snapshot.docs.isNotEmpty
        ? snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).first
        : UserModel();
    print("getUserByName : $user");
    return user;
  }

  void loadFriends() async {
    print(
        "loadFriends ${FirebaseAuth.instance.currentUser?.displayName}, $currentUser");
    final snapshot = await friendsCol.get();
    if (snapshot.docs.isNotEmpty) {
      // friends.assignAll(
      //     snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
      friends.value =
          snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    }
  }

  Future<void> sendFriendRequest(UserModel to) async {
    await col.doc(to.uid).set(
        FriendRequest(name: currentUser.value.name, createdAt: Timestamp.now())
            .toJson());
    await friendsCol.doc(to.uid).set({
      'name': to.name,
      'request': FriendRequest.pending,
      'createdAt': Timestamp.now()
    });
  }

  Future<void> addFriend(UserModel friend) async {
    if (friend.uid == currentUser.value.uid) {
      print("friend is current user");
      return;
    }
    await friendsCol.doc(friend.uid).set({
      'name': friend.name,
      'fcm_token': friend.token,
      'createdAt': Timestamp.now()
    });
    if (friends.contains(friend) == false) {
      print("add friend : $friend");
      friends.add(friend);
      //friends.refresh();
    }
  }

  Future<void> deleteFriend(UserModel friend) async {
    if (friend.uid == currentUser.value.uid) {
      print("friend is current user");
      return;
    }
    await friendsCol.doc(friend.uid).delete();
    friends.remove(friend);
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

  void observeFriendsCollection() {
    print("observeUserDoc");
    friendsDocumentSubscription =
        friendsCol.snapshots(includeMetadataChanges: true).listen((event) {
      friends.value = event.docChanges
          .map((document) => UserModel.fromSnapshot(document.doc))
          .toList();
    });
  }

  void observeRequestsCollection() {
    print("observeUserDoc");
    friendsDocumentSubscription =
        friendsCol.snapshots(includeMetadataChanges: true).listen((event) {
      final requests = event.docChanges
          .map((document) => FriendRequest.fromJson(document.doc as dynamic))
          .toList();
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

  void clear() {
    friends.clear();
    //FirebaseAuth.instance.authStateChanges().drain();
    authDocumentSubscription?.cancel();
    print(
        "clear $authDocumentSubscription, ${authDocumentSubscription?.isPaused}");
  }
}
