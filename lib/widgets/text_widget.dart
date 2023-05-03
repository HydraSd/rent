import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String placeHolder;
  final TextEditingController controller;
  const TextFieldWidget(
      {super.key, required this.placeHolder, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 14),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor),
        child: TextFormField(
          decoration:
              InputDecoration(hintText: placeHolder, border: InputBorder.none),
        ),
      ),
    );
  }
}
