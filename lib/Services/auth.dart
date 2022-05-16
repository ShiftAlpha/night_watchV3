// import 'package:night_watch/Views/signIn.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:html';

// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:night_watch3/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:night_watch/Views/dashboard.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:night_watch/Services/auth.dart';

class AuthService {
  // PermissionStatus _status;
  // Function toggleView;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  GuardUser? _userFromFirebaseUser(auth.User guardUsers) {
    // ignore: unnecessary_null_comparison
    return guardUsers != null ? GuardUser(uid: guardUsers.uid) : null;
  }

  // Stream<GuardUser> get user {
  //   return _auth.onAuthStateChanged
  //     //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  //     .map(_userFromFirebaseUser);
  // }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User? guardUsers = result.user;
      _handleCameraAndMic();
      return _userFromFirebaseUser(guardUsers!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User? guardUsers = result.user;
      //await DatabaseMethods(uid: user.uid).updateUserData('0','new crew member', 100);
      await _handleCameraAndMic();
      return _userFromFirebaseUser(guardUsers!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
  //   final GoogleSignIn _googleSignIn = new GoogleSignIn();

  //   final GoogleSignInAccount googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);

  //   AuthResult result = await _auth.signInWithCredential(credential);
  //   FirebaseUser userDetails = result.user;

  //   if (result == null) {
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  //   }
  // }

  Future handleSignOut() async {
    try{
      await _auth.signOut();
    await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  

  // Future<void> _handleCameraAndMic() async {
  
  //   await PermissionHandler().requestPermissions(
  //     PermissionGroup.microphone,
  //   );
  // }

    Future<bool> _handleCameraAndMic() async {
    final status = await Permission.microphone.isGranted;
    // bool isMic = status == ServiceStatus.enabled;

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
}
