import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/components/rounded_button.dart';
import 'package:flutter_application_4/constants.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String Email = '';
  String Password = '';
  final _cloud = FirebaseAuth.instance;
  bool ShowSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: ShowSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  Email = value;
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your Email ID:',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  Password = value;
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your Password:',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  setState(() {
                    ShowSpinner = true;
                  });

                  await _cloud.signInWithEmailAndPassword(
                      email: Email, password: Password);
                  Navigator.pushNamed(context, ChatScreen.id);
                  setState(() {
                    ShowSpinner = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
