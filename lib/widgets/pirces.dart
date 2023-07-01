// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Prices extends StatelessWidget {
  final double price;

  Prices({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat.currency(
      symbol: 'Rs.',
      decimalDigits: 2,
    ).format(price);
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
                  formattedPrice,
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
