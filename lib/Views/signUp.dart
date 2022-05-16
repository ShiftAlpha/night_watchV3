import 'package:night_watch3/helpers/helperFunctions.dart';
import 'package:night_watch3/services/auth.dart';
import 'package:night_watch3/services/database.dart';
import 'package:night_watch3/Views/dashboard.dart';
// import 'package:night_watch/widget/widget.dart';
import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  // ignore: use_key_in_widget_constructors
  const SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();

  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {
    // if (formKey.currentState.validate()) {
    //   // setState(() {
    isLoading = true;
    //   // });

    await authService
        .signUpWithEmailAndPassword(
            emailEditingController.text.toString().trim(),
            passwordEditingController.text.toString().trim())
        .then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          "Name": nameEditingController.text,
          "Email": emailEditingController.text,
          "Password": passwordEditingController.text
        };

        databaseMethods.addUserInfo(userDataMap);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
            nameEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(
            emailEditingController.text);

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
                begin: Alignment.centerRight,
                end: Alignment.bottomLeft,
                //radius: 3.5,
                //center: Alignment.topRight,
                colors: gradient1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Opacity(
                      opacity: 0.81,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Register',
                            style: TextStyle(
                              foreground: Paint()..shader = linearGradient,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(45.0),
                  //   child: RotatedBox(
                  //     quarterTurns: 3,
                  //     child: Text(
                  //       'Night Watch',
                  //       style: TextStyle(
                  //           fontSize: 50,
                  //           fontWeight: FontWeight.bold,
                  //           foreground: Paint()..shader = linearGradient),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: TextFormField(
                        controller: nameEditingController,
                        validator: (val) {
                          return val!.isEmpty || val.length < 3
                              ? "Enter Username 3+ characters"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Opacity(
                      opacity: 0.3,
                      child: TextFormField(
                        controller: emailEditingController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Opacity(
                      opacity: 0.3,
                      child: TextFormField(
                        controller: passwordEditingController,
                        validator: (val) {
                          return val!.length < 6
                              ? "Enter Password 6+ characters"
                              : null;
                        },
                        onChanged: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Opacity (
                      opacity: 0.3,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                          hintText: 'Mobile No.',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 36),
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
                        primary: Colors.white,
                      ),
                      child: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        signUp();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    const Opacity(
                      opacity: 0.4,
                      child: Text(
                        'You are here first Time? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.toggleView(),
                      child: const Text(
                        'Sign in',
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
}
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.black,
//     body: isLoading
//         ? Container(
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : Container(
//             padding: EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               children: [
//                 Spacer(),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         style: simpleTextStyle(),
//                         controller: nameEditingController,
//                         validator: (val) {
//                           return val.isEmpty || val.length < 3
//                               ? "Enter Username 3+ characters"
//                               : null;
//                         },
//                         decoration: textFieldInputDecoration("Name"),
//                       ),
//                       TextFormField(
//                           controller: emailEditingController,
//                           style: simpleTextStyle(),
//                           decoration: textFieldInputDecoration("Group ID"),
//                           // validator: (val) => EmailValidator.validate(val)
//                           //        ? 'Email structure is incorrect'
//                           //        : null,

//                            ),
//                       TextFormField(
//                         obscureText: true,
//                         // style: simpleTextStyle(),
//                         decoration: textFieldInputDecoration("password"),
//                         controller: passwordEditingController,
//                         validator: (val) {
//                           return val.length < 6
//                               ? "Enter Password 6+ characters"
//                               : null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     signUp();
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.lightGreen),
//                       color: Colors.black,
//                     ),
//                     width: MediaQuery.of(context).size.width,
//                     child: Text(
//                       "Sign Up",
//                       style: TextStyle(fontSize: 17, color: Colors.lightGreen),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     border: Border.all(color: Colors.lightGreen),
//                     color: Colors.black,
//                   ),
//                   width: MediaQuery.of(context).size.width,
//                   child: Text(
//                     "Sign Up with Ethereum address",
//                     style: TextStyle(fontSize: 12, color: Colors.lightGreen),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         widget.toggleView();
//                       },
//                       child: Text(
//                         "Sign In",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 19),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 50,
//                 )
//               ],
//             ),
//           ),
//   );
//   ;
// }
