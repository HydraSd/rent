import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  const ProductName({
    Key? key,
    required this.nameController,
    required this.focusNode,
    required this.nameError,
  }) : super(key: key);

  final TextEditingController nameController;
  final FocusNode focusNode;
  final bool nameError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 14),
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardColor),
            child: TextFormField(
              controller: nameController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                  hintText: "Enter the product name", border: InputBorder.none),
            ),
          ),
        ),
        Visibility(
          visible: nameError,
          child: const Padding(
            padding: EdgeInsets.only(left: 8, top: 5),
            child: Text(
              "Please enter your product name",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
