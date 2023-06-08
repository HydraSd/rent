// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Prices extends StatelessWidget {
  final String price;

  Prices({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 120,
            child: Column(children: [
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Price",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Rs. $price",
                  style: const TextStyle(fontSize: 20),
                ),
              ))
            ]),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
