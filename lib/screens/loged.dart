import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/home_screen.dart';
import 'package:rent/screens/login_screen.dart';

class Loged extends StatelessWidget {
  const Loged({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        return const LoginScreen();
      },
    );
  }
}
