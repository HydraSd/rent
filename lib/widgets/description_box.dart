import 'package:flutter/material.dart';

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({
    Key? key,
    required this.desController,
    required this.focusNode,
    required this.desError,
  }) : super(key: key);

  final TextEditingController desController;
  final FocusNode focusNode;
  final bool desError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                controller: desController,
                focusNode: focusNode,
                maxLines: 8,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter a small description"),
              )),
          Visibility(
            visible: desError,
            child: const Padding(
              padding: EdgeInsets.only(left: 8, top: 5),
              child: Text(
                "Please enter a small description",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
