import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// ignore: camel_case_types
class panicPage extends StatefulWidget {
  const panicPage({Key? key}) : super(key: key);

  @override
  State<panicPage> createState() => _panicPageState();
}

// ignore: camel_case_types
class _panicPageState extends State<panicPage> {

  String phoneNumber ='+27788945888';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 40, 20),
              height: 1,
              color: Colors.white,
            ),
            ArgonTimerButton(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.45,
              minWidth: MediaQuery.of(context).size.width * 0.30,
              highlightColor: Colors.transparent,
              highlightElevation: 0,
              roundLoadingShape: false,
              onTap: (startTimer, btnState) {
                if (btnState == ButtonState.Idle) {
                  // startTimer(5);
                  FlutterPhoneDirectCaller.callNumber(phoneNumber);
                  // _dialCall();
                }
                const Text("PANIC");
              },
              // initialTimer: 10,
              child: const Text(
                "Resend Panic",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              loader: (timeLeft) {
                return Text(
                  "Tap away | $timeLeft",
                  
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                      
                );
                
              },
              borderRadius: 5.0,
              color: Colors.transparent,
              elevation: 0,
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),

            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              height: 1,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  // Future<void> _dialCall() async {
  //   String phoneNumber ='+27788945888';
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   // await launchUrl(launchUri);

  // }
 
}
