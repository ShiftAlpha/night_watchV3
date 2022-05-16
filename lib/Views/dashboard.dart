// ignore_for_file: avoid_print

import 'dart:async';
// import 'dart:ui';

import 'package:night_watch3/Views/chatRoom.dart';
import 'package:flutter/material.dart';
import 'package:night_watch3/Views/maps.dart';
import 'package:night_watch3/profile/profile.dart';
import 'package:night_watch3/Views/panic.dart';
// import 'package:night_watch/Services/auth.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/status.dart' as status;
//import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
// import 'package:holding_gesture/holding_gesture.dart';
// import 'package:audioplayers/audioplayers.dart';
//import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:mic_stream/mic_stream.dart';
// import 'package:audio_recorder/audio_recorder.dart';
//import 'package:night_watch/Views/list.dart';
// import 'package:file/file.dart';
// import 'package:file/local.dart';


enum Command {
  start,
  stop,
  change,
}

// const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Stream<List<int>> stream;
  // ignore: cancel_subscriptions
  late StreamSubscription<List<int>> listener;
  late List<int> currentSamples;

  // var recorder = FlutterAudioRecorder("file_path.mp4"); // .wav .aac .m4a
  // FlutterAudioRecorder _recorder;
  // Recording _current;
  // RecordingStatus _currentStatus = RecordingStatus.Unset;

  // final LocalFileSystem localFileSystem;

  bool isRecording = false;
  bool memRecordingState = false;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  // void _controlMicStream({Command command: Command.change}) async {
  //   switch (command) {
  //     case Command.change:
  //       _changeListening();
  //       break;
  //     case Command.start:
  //       _startListening();
  //       break;
  //     case Command.stop:
  //       _stopListening();
  //       break;
  //   }
  // }

  // bool _changeListening() =>
  //     !isRecording ? _startListening() : _stopListening();

  // bool _startListening() {
  //   if (isRecording) return false;
  //   stream = microphone(
  //       audioSource: AudioSource.MIC,
  //       sampleRate: 16000,
  //       channelConfig: ChannelConfig.CHANNEL_IN_MONO,
  //       audioFormat: AUDIO_FORMAT,
  //       );

  //   setState(() {
  //     isRecording = true;
  //   });

  //   print("Start Listening to the microphone");
  //   listener = stream.listen((samples) => currentSamples = samples);
  //   return true;
  // }

  // bool _stopListening() {
  //   if (!isRecording) return false;
  //   print("Stop Listening to the microphone");
  //   listener.cancel();

  //   setState(() {
  //     isRecording = false;
  //     currentSamples = null;
  //   });
  //   return true;
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;
      print("Resume app");

      // _controlMicStream(
      //     command: memRecordingState ? Command.start : Command.stop);
    } else if (isActive) {
      // memRecordingState = isRecording;
      // _controlMicStream(command: Command.stop);

      print("Pause app");
      isActive = false;
    }
  }

  @override
  void dispose() {
    listener.cancel();

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  // Properties & Variables needed
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    const ChatRoom(),
    Maps3(),
    const panicPage(),
    //Profile(),
    //Settings(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const ChatRoom(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            const ChatRoom(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.messenger_outline_sharp,
                          color: currentTab == 0 ? Colors.white : Colors.grey,
                        ),
                        const Text(
                          '',
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Maps3(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_searching_sharp,
                          color: currentTab == 1 ? Colors.white: Colors.grey,
                        ),
                        const Text(
                          '',
                          style: TextStyle(color: Color.fromARGB(255, 30, 53, 3)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                // heightFactor: 0.5,
                child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.radio_button_off_sharp),
                    // elevation: 1,
                    onPressed: () {
                      const Icon(Icons.radio_button_on_sharp);
                      
                    }),
              ),
              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            const ProfileInfo(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.verified_user_sharp,
                          color: currentTab == 2 ? Colors.white : Colors.grey,
                        ),
                        const Text(
                          '',
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      print("");
                      // AuthService().signOut();
                      setState(() {
                        currentScreen =
                        const panicPage(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.emergency_outlined,
                          color: currentTab == 3 ? Colors.white : Colors.grey,
                        ),
                        const Text(
                          '',
                          style: TextStyle(color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
