import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/screens/screens.dart';

class UpdateProduct extends StatelessWidget {
  const UpdateProduct({
    Key? key,
    required this.documentId,
    required this.productName,
    required this.price,
    required this.description,
  }) : super(key: key);

  final String documentId;
  final String productName;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      child: Bounceable(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UpdateScreen(
                    documentId: documentId,
                    productName: productName,
                    price: price,
                    description: description,
                  )));
        },
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: const Center(
                child: Text(
              "Update product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
