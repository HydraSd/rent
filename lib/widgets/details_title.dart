import 'package:flutter/material.dart';
import 'package:rent/widgets/pirces.dart';

class Title1 extends StatelessWidget {
  final String productName;
  final String catagory;
  final String description;
  final double price;

  final double lat;
  final double long;

  final String location;
  const Title1(
      {required this.productName,
      required this.catagory,
      required this.description,
      required this.price,
      required this.location,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Row(
            children: const [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Catagory product belongs: $catagory",
                style: const TextStyle(fontSize: 16)),
          ),
          Prices(price: price),
        ],
      ),
    );
  }
}
