// ignore_for_file: unnecessary_null_comparison

import 'package:night_watch3/Views/dashboard.dart';
import 'package:night_watch3/helpers/authenticate.dart';
import 'package:night_watch3/helpers/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool userIsLoggedIn = false;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  void getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff145C9E),
        scaffoldBackgroundColor: const Color(0xff1F1F1F),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xff007EF4)),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? const Home()
              : const Authenticate()
          : const Center(
              child: Authenticate(),
            ),
    );
  }
}
