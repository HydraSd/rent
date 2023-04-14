import 'package:flutter/material.dart';

class HeaderTitles extends StatelessWidget {
  final String title;
  const HeaderTitles({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Icon(Icons.arrow_forward)
      ],
    );
  }
}
