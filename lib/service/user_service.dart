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
  UserModel? currentUser;
  StreamSubscription? userDocumentSubscription;

  CollectionReference get col => FirebaseFirestore.instance.collection('users');
  DocumentReference get doc => col.doc(FirebaseAuth.instance.currentUser?.uid);
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference get friendsCol => doc.collection('friends');

  void init() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      print("authStateChanges called");
      if (firebaseUser == null) {
        print("startService - firebaseUser is null");
        unobserveUserDoc();
        print("startService - route is ${Get.currentRoute}");
        if (Get.currentRoute != AppRoute.LOGIN) {
          Get.offAllNamed(AppRoute.LOGIN);
        }
      } else {
        if (currentUser?.uid != firebaseUser.uid) {
          print("startService - currentUser is null");
          getUser(firebaseUser.uid).then((user) async {
            if (user.exists == false || user.createdAt == null) {
              // user doc 생성
              print("No user document exists : ${user.name}");
              user.update({'createdAt': Timestamp.now()});
            }
          });
        }
        observeUserDoc();
        print("after observeUserDoc");
        print("startService2 - route is ${Get.currentRoute}");
        if (Get.currentRoute != AppRoute.HOME) {
          Get.offAllNamed(AppRoute.HOME);
        }
        // Get.offAllNamed(AppRoute.HOME);
      }
    });
  }

  Map<String, UserModel> userDocumentContainer = {};
  Future<UserModel> getUser(
    String uid, {
    bool cache = true,
  }) async {
    final snapshot = await col.doc(uid).get();
    //userDocumentContainer[uid] = UserModel.fromSnapshot(snapshot);
    //return userDocumentContainer[uid]!;
    return UserModel.fromSnapshot(snapshot);
  }

  Future<UserModel> getUserByName(String name) async {
    final snapshot = await col.where('name', isEqualTo: name).get();
    final user = snapshot.docs.isNotEmpty
        ? snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).first
        : UserModel();
    print("getUserByName : ${user}");
    return user;
  }

  Future<List<UserModel>> getFriends() async {
    final snapshot = await friendsCol.get();
    return snapshot.docs.isNotEmpty
        ? snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList()
        : <UserModel>[];
  }

  Future<void> addFriend(UserModel friend) async {
    if (friend.uid == currentUser?.uid) {
      print("friend is current user");
      return;
    }
    friendsCol
        .doc(friend.uid)
        .set({'name': friend.name, 'createdAt': Timestamp.now()});
  }

  Future<void> deleteFriend(UserModel friend) async {
    if (friend.uid == currentUser?.uid) {
      print("friend is current user");
      return;
    }
    await friendsCol.doc(friend.uid).delete();
  }

  void observeUserDoc() {
    userDocumentSubscription?.cancel();
    userDocumentSubscription =
        doc.snapshots().listen((DocumentSnapshot snapshot) async {
      if (snapshot.exists == false) {
        // log('---> User document not exits in observeUserDoc.');
        print('---> User document not exits in observeUserDoc.');
      }
      currentUser = UserModel.fromSnapshot(snapshot);
      // log('----> observeUserDoc and update event with; $user');
      //userChange.add(user);
      print('----> observeUserDoc and update event with; $currentUser');
    });
  }

  /// 로그아웃을 할 때 호출되며, 사용자 모델(user)을 초기화하고, listening 해제하고, 이벤트를 날린다.
  void unobserveUserDoc() {
    userDocumentSubscription?.cancel();
    currentUser = UserModel();
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
