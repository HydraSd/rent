import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDistance {
  final DocumentSnapshot product;
  final double distance;

  ProductDistance(this.product, this.distance);
}
