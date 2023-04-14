// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Prices extends StatelessWidget {
  final String price;
  final String weekendPrice;
  Prices({super.key, required this.price, required this.weekendPrice});

  bool weekEndChecker() {
    if (weekendPrice == '') {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Week day",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    price,
                    style: const TextStyle(fontSize: 18),
                  ),
                ))
              ]),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Week end ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    (weekEndChecker()) ? weekendPrice : '$price',
                    style: const TextStyle(fontSize: 18),
                  ),
                ))
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
