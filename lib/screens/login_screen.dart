import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent/func/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo2.png"),
                    fit: BoxFit.fill)),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Welcome to RentMate",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: const _LoginButton(),
            ),
          ),
          const SizedBox(height: 15),
          const Text("Please log in to your account from here.")
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/google.png'))),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
