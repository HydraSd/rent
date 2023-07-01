import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:rent/screens/user_details_screen.dart';

class RequestBtn extends StatelessWidget {
  final String btnText;
  final Color btnColor;
  final double paddingTop;
  final double paddingbottom;
  final double paddingleft;
  final double paddingright;

  const RequestBtn({
    Key? key,
    required this.btnText,
    this.btnColor = Colors.blue,
    this.paddingTop = 30,
    this.paddingbottom = 30,
    this.paddingleft = 30,
    this.paddingright = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: paddingTop,
            bottom: paddingbottom,
            left: paddingleft,
            right: paddingright),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: btnColor),
            child: Center(
                child: Text(
              btnText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        ));
  }
}
