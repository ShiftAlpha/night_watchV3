// ignore_for_file: avoid_print, unnecessary_string_escapes, duplicate_ignore

import 'dart:async';
import 'dart:ffi';

import 'package:night_watch3/Helpers/constants.dart';
import 'package:night_watch3/services/database.dart';
import 'package:night_watch3/views/chat.dart';
import 'package:night_watch3/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
// import 'package:night_watch/Views/dashboard.dart';
// import 'package:audio_recorder/audio_recorder.dart';

// import '';

enum Command {
  start,
  stop,
  change,
}
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

    late Stream<List<int>> stream;
  // ignore: cancel_subscriptions
  late StreamSubscription<List<int>> listener;
  late List<int> currentSamples;

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;


  bool isRecording = false;
  bool memRecordingState = false;
  late bool isActive;


    void _controlMicStream({Command command = Command.change}) async {
    switch (command) {
      case Command.change:
        _changeListening();
        break;
      case Command.start:
        _startListening();
        break;
      case Command.stop:
        _stopListening();
        break;
    }
  }

  bool _changeListening() =>
      !isRecording ? _startListening() : _stopListening();

  bool _startListening() {
    // if (isRecording) return false;
    // stream = microphone(
    //     // audioSource: AudioSource.MIC,
    //     sampleRate: 16000,
    //     // channelConfig: ChannelConfig.CHANNEL_IN_MONO,
    //     audioFormat: AUDIO_FORMAT,
    //     );

    setState(() {
      isRecording = true;
    });

    print("Start Listening to the microphone");
    listener = stream.listen((samples) => currentSamples = samples);
    return true;
  }

  bool _stopListening() {
    if (!isRecording) return false;
    print("Stop Listening to the microphone");
    listener.cancel();
    setState(() {
      isRecording = false;
      // currentSamples =  null;
    });
    return true;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;
      print("Resume app");

      _controlMicStream(
          command: memRecordingState ? Command.start : Command.stop);
    } else if (isActive) {
      memRecordingState = isRecording;
      _controlMicStream(command: Command.stop);

      print("Pause app");
      isActive = false;
    }
  }

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.docs[index].get("Name")["Name"],
          searchResultSnapshot.docs[index].get("Email"),
        );
        }) : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];
    // ignore: unused_local_variable
    List<String> usersVoice = [Constants.mydoc,];
  
    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "guardUsers": users,
      "ChatRoomID" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId: chatRoomId,
      )
    ));

  }

  

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
           const Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: const Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12
                ),),
            ),
          ),
          const Spacer(),
          HoldDetector(
            onHold: () => _startListening(),
            enableHapticFeedback: true,
            onCancel: () => _stopListening(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: const Text("Voice",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12
                ),),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      // ignore: unnecessary_string_escapes
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :  Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0x54FFFFFF),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchEditingController,
                    // style: simpleTextStyle(),
                    decoration: const InputDecoration(
                      hintText: "search username ...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png",
                        height: 25, width: 25,)),
                )
              ],
            ),
          ),
          userList()
        ],
      ),
    );
  }
}


