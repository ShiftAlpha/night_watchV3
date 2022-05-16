// import 'dart:html';
import 'package:night_watch3/helpers/helperFunctions.dart';
import 'package:night_watch3/services/auth.dart';
import 'package:night_watch3/services/database.dart';
// import 'package:night_watch/Views/forgotPass.dart';
import 'package:night_watch3/Views/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:night_watch/widget/widget.dart';
// import 'package:email_validator/email_validator.dart';

// import 'package:night_watch/widget/verticalText.dart';
// import 'package:night_watch/widget/textLogin.dart';
// import 'package:night_watch/widget/inputName.dart';
// import 'package:night_watch/widget/password.dart';
// import 'package:night_watch/widget/button.dart';
// import 'package:night_watch/widget/first.dart';

class Signin extends StatefulWidget {
  final Function toggleView;

  // ignore: use_key_in_widget_constructors
  const Signin(this.toggleView);

  @override
  _Signin createState() => _Signin();
}

class _Signin extends State<Signin> {
  TextEditingController emailTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController =
      TextEditingController();

  AuthService authService =  AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signin() async {
    // if (formKey.currentState.validate()) {
    //   setState(() {
    isLoading = true;
    //   });

    await authService
        .signInWithEmailAndPassword(
            emailTextEditingController.text.toString().trim(),
            passwordTextEditingController.text.toString().trim())
        .then((result) async {
      switch (result) {
        case null:
          setState(() {
            isLoading = false;
            //show snackbar
          });
          break;

        default:
          QuerySnapshot userInfoSnapshot = await DatabaseMethods()
              .getUserInfo(emailTextEditingController.text.trim());

          HelperFunctions.saveUserLoggedInSharedPreference(false);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0].get("Name"));
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0].get("Email"));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
      }
    });
    // }
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight, end: Alignment.bottomLeft,
              //For Properties for Radial Gradient
              // radius: 3.5,
              //center: Alignment.topRight,
              colors: gradient1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // const Align(alignment: Alignment.center),
                  
                  Padding(
                    padding: const EdgeInsets.all(45),
                    child: Opacity(
                      opacity: 0.81,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Opacity(
                            opacity: 0.3,
                          ),
                          Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.all(55.0),
                  //     child: RotatedBox(
                  //       quarterTurns: 3,
                  //       child: Text(
                  //         'Night Watch',
                  //         style: TextStyle(
                  //             fontSize: 60,
                  //             fontWeight: FontWeight.bold,
                  //             foreground: Paint()..shader = linearGradient),
                  //       ),
                  //     )),
                ],
              ),
              Form(
                  child: Column(
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: TextFormField(
                      controller: emailTextEditingController,
                      onChanged: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 45),
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: TextFormField(
                      controller: passwordTextEditingController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 45),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                ],
              )),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          primary: Colors.white),
                      onPressed: () {
                        //  Navigator.pushReplacement(context,
                        //      MaterialPageRoute(builder: (context) => Home()));
                        signin();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                           Text(
                            'Ok',
                            style: TextStyle(color:  Color(0xFF1E7879)),
                          ),
                           SizedBox(
                            width: 10,
                          ),
                           Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF1E7879),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.00),
                child: Row(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4,
                      child: Text(
                        'Register ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.toggleView(),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           const SizedBox(height: 100.0),
  //           Stack(
  //             children: <Widget>[
  //               Positioned(
  //                 top: 15.0,
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20.0)),
  //                   width: 100.0,
  //                   height: 30.0,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(),
  //                 child: Text(
  //                   "Welcome",
  //                   style: TextStyle(
  //                       fontSize: 50.0,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.lightGreen),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 120.0),
  //           Form(
  //             key: formKey,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 32, vertical: 8.0),
  //                   child: TextFormField(
  //                     controller: emailTextEditingController,
  //                     decoration: textFieldInputDecoration("User ID"),
  //                     //   validator: (val) => EmailValidator.validate(val)
  //                     //       ? 'Email structure is incorrect'
  //                     //       : null,
  //                     //

  //                     //   // decoration: InputDecoration(
  //                     //   //     labelText: "Email",
  //                     //   //     hasFloatingPlaceholder: true,
  //                     //   //     labelStyle: TextStyle(color: Colors.white)),
  //                   ),
  //                 ),
  //                 Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 32, vertical: 8.0),
  //                     child: TextFormField(
  //                       controller: passwordTextEditingController,
  //                       validator: (val) {
  //                         return val.length > 6
  //                             ? null
  //                             : "Enter Password 6+ characters";
  //                       },
  //                       decoration: textFieldInputDecoration("Password"),
  //                       obscureText: true,
  //                       //   decoration: InputDecoration(
  //                       //       labelText: "Password",
  //                       //       hasFloatingPlaceholder: true,
  //                       //       labelStyle: TextStyle(color: Colors.white)),
  //                       // ),
  //                     )),
  //               ],
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) => ForgotPassword()));
  //             },
  //             child: Container(
  //                 alignment: Alignment.center,
  //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
  //                 child: Text(
  //                   "",
  //                   style: TextStyle(fontSize: 17, color: Colors.lightGreen),
  //                   textAlign: TextAlign.center,
  //                 )),
  //           ),
  //           const SizedBox(height: 80.0),
  //           Align(
  //             alignment: Alignment.center,
  //             child: RaisedButton(
  //               padding: const EdgeInsets.fromLTRB(30.0, 16.0, 30.0, 16.0),
  //               color: Colors.black,
  //               elevation: 0,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(15.0),
  //                 topRight: Radius.circular(15.0),
  //                 bottomRight: Radius.circular(15.0),
  //                 bottomLeft: Radius.circular(15.0),
  //               )),
  //               onPressed: () {
  //                 login();
  //               },
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Text(
  //                     "Sign In",
  //                     style: TextStyle(

  //                         fontSize: 16.0,
  //                         color: Colors.lightGreen),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   // Icon(
  //                   //   FontAwesomeIcons.arrowRight,
  //                   //   size: 18.0,
  //                   // )
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Text(
  //             "        ",
  //             style: TextStyle(fontSize: 17, color: Colors.white),
  //             textAlign: TextAlign.center,
  //           ),
  //           GestureDetector(
  //             child: Text(
  //               "",
  //               style: TextStyle(
  //                   color: Colors.lightGreen,
  //                   fontSize: 16,
  //                   decoration: TextDecoration.underline),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               widget.toggleView();
  //             },
  //             child: Text(
  //               "Register",
  //               style: TextStyle(color: Colors.white, fontSize: 16),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 100,
  //           ),
  //           Text("Powered by GENESIS",
  //               style: TextStyle(color: Colors.lightBlue, fontSize: 10),)
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
