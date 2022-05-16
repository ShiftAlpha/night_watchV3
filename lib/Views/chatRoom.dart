// ignore_for_file: avoid_print

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:night_watch3/Helpers/constants.dart';
import 'package:night_watch3/Helpers/HelperFunctions.dart';
import 'package:night_watch3/Helpers/authenticate.dart';
import 'package:night_watch3/Views/search.dart';
import 'package:night_watch3/Services/database.dart';
import 'package:night_watch3/Services/auth.dart';
import 'package:night_watch3/Views/chat.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late Stream chatRoom;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.toString().length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    name: snapshot.data!.docs[index]['ChatRoomID']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data!.docs[index]["ChatRoomID"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRoom = snapshots;
        print(
            "we got the data + ${chatRoom.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.grey.shade100, Colors.black87],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  List<Color> gradient1 = [Colors.black54, Colors.grey.shade800];
  List<Color> gradient2 = [Colors.grey.shade800, Colors.grey];
  List<Color> gradient3 = [Colors.deepPurple, Colors.purpleAccent];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Image.asset(
        //   // "assets/images/logo.png",
        //   height: 40,
        // ),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Colors.black,
        // flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.centerRight,
        //     end: Alignment.bottomLeft,
        //     colors: gradient1,
        //   ),
        // )),
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().handleSignOut();

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authenticate()));
            },
            child: Container(
              color: Colors.black,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.centerRight,
                //     end: Alignment.bottomLeft,
                //     colors: gradient1,
                //   ),
                // ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.logout_sharp)),
          )
        ],
      ),
      body: Container(
        // child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.green,
        backgroundColor: Colors.black,
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String name;
  final String chatRoomId;

  // ignore: prefer_const_constructors_in_immutables
  ChatRoomsTile({Key? key, required this.name, required this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(chatRoomId: chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  //color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(name.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(name,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
