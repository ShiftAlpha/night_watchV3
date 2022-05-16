// import 'dart:convert';

// import 'dart:html';

// ignore_for_file: must_be_immutable, avoid_print, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:night_watch3/helpers/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
// import 'package:audio_recorder/audio_recorder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:night_watch/services/database.dart';

class Microphone extends StatelessWidget {
  final bool isRecording;
  final Function onStartRecording;
  final Function onStopRecording;

  const Microphone({Key? key, 
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.permissionHandler,
  }) : super(key: key);

  final Permission permissionHandler;
  // ignore: unused_field
  final PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 10.0,
        color: isRecording ? kColourIsRecording : kColourPrimary,
        child: const Icon(
          Icons.mic,
          size: 10.0,
          color: Colors.white,
        ),
      ),
      onTapDown: (TapDownDetails details) {
        startRecording();
      },
      onTapUp: (TapUpDetails details) {
        stopRecording();
      },
    );
  }

  void startRecording() async {
    try {
      if (await hasPermissions()) {
        onStartRecording();
        String path = await getFilePath();
        await FlutterSoundRecorder()
            .startRecorder(toFile: path, codec: Codec.defaultCodec);
      }
    } catch (error) {
      print(error);
    }
  }

  void stopRecording() async {
    if (isRecording) {
      onStopRecording();
      var recording = await FlutterSoundRecorder().stopRecorder();
      sendRecording(recording!);
    }
  }

  void sendRecording(String path) {
    final fileName = path.split('/').last;
    FirebaseStorage.instance.ref().child(fileName).putFile(File(path));
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .add({'filename': fileName});

    //DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
  }

  Future<bool> hasPermissions() async {
    final status = await Permission.microphone.isGranted;
    // ignore: unused_local_variable
    bool isMic = status == ServiceStatus.enabled;

    final stat = await Permission.microphone.request();

    if (stat == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
    return false;
  }

  Future<String> getFilePath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String timestamp = DateTime.now().toIso8601String();
    return appDocDirectory.path + '/recording_' + timestamp + '.m4a';
  }
}
