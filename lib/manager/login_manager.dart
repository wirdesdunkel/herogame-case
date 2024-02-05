import 'package:flutter/material.dart';

import 'package:herogame_case/manager/firebase.dart';
import 'package:herogame_case/screen/home_screen.dart';
import 'package:herogame_case/screen/login_screen.dart';

class LoginManager extends StatefulWidget {
  const LoginManager({super.key});

  @override
  State<LoginManager> createState() => _LoginManagerState();
}

class _LoginManagerState extends State<LoginManager> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseManager().auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
