import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String image;
  const Avatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
    );
  }
}
