// import 'package:audio_recorder/audio_recorder.dart';
import 'package:night_watch3/Helpers/constants.dart';
import 'package:night_watch3/model/user.dart';
// import 'package:night_watch/Services/microphone.dart';
// import 'package:night_watch/Services/recordings_stream.dart';
import 'package:night_watch3/services/database.dart';
import 'package:night_watch3/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  // ignore: use_key_in_widget_constructors
  const Chat({required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  bool isRecording = false;
  late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = TextEditingController();

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.docs[index]['message'],
                sendByMe: Constants.myName == snapshot.data!.docs[index]["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('messages')
          .doc('chatRoomID')
          .collection('chatRoomID')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "senderId": GuardUser,
          // "anotherUserId": widget['id'],
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": audioMsg,
          "type": 'audio'
        });
      }).then((value) {
        setState(() {
          isRecording = false;
        });
      });
      // scrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    // } else {
    //   print("Hello");
    }
  }

// addVoice() {
//     if (messageEditingController.text.isNotEmpty) {
//       Map<String, dynamic> chatMessageMap = {
//         "sendBy": Constants.myName,
//         "message": messageEditingController.text,
//         'time': DateTime
//             .now()
//             .millisecondsSinceEpoch,
//       };

//       DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

//       setState(() {
//         messageEditingController.text = "";
//       });
//     }
//   }
  

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      body: Stack(
        children: [
          chatMessages(),
          Container(alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: <Widget> [
                  GestureDetector(
                    // onTap: () {
                    //   Microphone(
                    //     isRecording: isRecording, 
                    //     onStartRecording:(){
                    //       setState(() {
                            
                    //         isRecording = true;
                    //       });
                    //     }, 
                    //     onStopRecording: () {
                    //       setState(() {
                    //         isRecording = false;
                    //       });
                    //     });
                    // },
                    child: Container(
                        height: 40,
                        width: 30,
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
                        padding: const EdgeInsets.only(left: 30),
                        child: Image.asset("",
                          height: 25, width: 25,)),
                  ),
                  Expanded(
                    
                      child: TextField(
                        controller: messageEditingController,
                        style: simpleTextStyle(),
                        
                        decoration: const InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                        
                      )
                      ),
                      
                  const SizedBox(width: 16,)
                  ,
                  
                  GestureDetector(
                    onTap: () {
                      addMessage();
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
                        padding: const EdgeInsets.all(20),
                        child: Image.asset("assets/images/send.png",
                          height: 25, width: 25,)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  // ignore: use_key_in_widget_constructors
  const MessageTile({required this.message, required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            const BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            // gradient: LinearGradient(
            //   // colors: sendByMe ? [
            //   //   const Color(0xff007EF4),
            //   //   const Color(0xff2A75BC)
            //   // ]
            //        [
            //     const Color(0x1AFFFFFF),
            //     const Color(0x1AFFFFFF)
            //   ],
            // )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}

