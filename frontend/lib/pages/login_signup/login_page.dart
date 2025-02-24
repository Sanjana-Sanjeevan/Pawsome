// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/chats/Chat.dart';
// import 'package:pawsome/pages/login_signup/signup_page.dart';
// import 'package:login_signup/pages/home_page.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/utils/color_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextControler = TextEditingController();
  TextEditingController _passwordTextControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor('FF6D00'), // ff6600 CB2B93
              hexStringToColor('ffa31a'), //  9546C4
              hexStringToColor('ffb84d')  // ffd633  ffa31a 5E61F4
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              logoWidget('assets/images/pawsome_logo.jpeg'),
              SizedBox(
                height: 30,
              ),
              reusableTextField('Enter Username', Icons.person_outline, false, _emailTextControler),
              SizedBox(
                height: 20,
              ),
              reusableTextField('Enter Password', Icons.lock_outline, true, _passwordTextControler),
              SizedBox(
                height: 30,
              ),

              // login using firebase auth
              firebaseUIButton(context, 'LOGIN' , () {
                // FirebaseAuth.instance.signInWithEmailAndPassword(
                //     email: _emailTextControler.text,
                //     password: _passwordTextControler.text).then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chat()));  // *** HomePage  - BUT Still No Homepage ****
                // })
                // .onError((error, stackTrace) {
                //   print("Error ${error.toString()}");
                // });
              }),
              signUpOption()
            ],
          ),
        )
      ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 15)),
        GestureDetector(
          onTap: () {
            style: TextStyle(color: Colors.black);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Chat())); // *** Should go to HomePage****
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16 ),
          ),
        )
      ],
    );
  }
}
