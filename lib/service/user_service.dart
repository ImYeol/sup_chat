import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/model/user_model.dart';
import 'package:sup_chat/model/user_status.dart';

class UserService extends GetxService {
  final currentUser = UserModel().obs;
  final friends = <UserModel>[].obs;
  StreamSubscription? userDocumentSubscription;

  CollectionReference get col => FirebaseFirestore.instance.collection('users');
  DocumentReference get doc => col.doc(FirebaseAuth.instance.currentUser?.uid);
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get friendsCol => doc.collection('friends');

  void init() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        print("authStateChanges - firebaseUser is null");
        unobserveUserDoc();
        if (Get.currentRoute != AppRoute.LOGIN) {
          Get.offAllNamed(AppRoute.LOGIN);
        }
      } else {
        print("authStateChanges - user is ${firebaseUser.displayName}");
        UserModel().update({
          'name': firebaseUser.displayName,
          'uid': firebaseUser.uid,
          'createdAt': Timestamp.now()
        });
        observeUserDoc();
        loadFriends();
      }
    });
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
    print("loadFriends");
    final snapshot = await friendsCol.get();
    if (snapshot.docs.isNotEmpty) {
      friends.assignAll(
          snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
    }
  }

  Future<void> addFriend(UserModel friend) async {
    if (friend.uid == currentUser.value.uid) {
      print("friend is current user");
      return;
    }
    friendsCol
        .doc(friend.uid)
        .set({'name': friend.name, 'createdAt': Timestamp.now()});
    if (friends.contains(friend) == false) {
      print("add friend : $friend");
      friends.add(friend);
      friends.refresh();
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

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
