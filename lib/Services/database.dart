// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //   final String uid;
  //   DatabaseMethods({ this.uid });

  // final CollectionReference guardUser = Firestore.instance.collection('guardUsers');

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("guardUsers")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("guardUsers")
        .where("Email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("guardUsers")
        .where('Name', isEqualTo: searchField)
        .get();
  }

  // ignore: missing_return
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e.toString());
    });
    return chatRoom;
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String myName) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('guardUsers', arrayContains: myName)
        .snapshots();
  }
}
