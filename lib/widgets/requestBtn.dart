import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:rent/screens/user_details_screen.dart';

class RequestBtn extends StatelessWidget {
  const RequestBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: const Center(
                child: Text(
              "Request Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        ));
  }
}
