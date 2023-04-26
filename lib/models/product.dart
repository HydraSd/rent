import 'package:google_maps_flutter/google_maps_flutter.dart';

class Product {
  String id;
  final String productName;
  final String catagory;
  final List imgUrl;
  final String description;
  final String price;
  final String weekendPrice;
  final String userID;
  final double lat;
  final double long;
  final String location;
  final String phoneNumber;
  Product(
      {this.id = '',
      required this.price,
      required this.weekendPrice,
      required this.imgUrl,
      required this.productName,
      required this.description,
      required this.catagory,
      required this.userID,
      required this.lat,
      required this.long,
      required this.location,
      required this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'id': id,
        'productName': productName,
        'category': catagory,
        'description': description,
        'price': price,
        'weekendPrice': weekendPrice,
        'userId': userID,
        'location': location,
        'lat': lat,
        'long': long,
        'phoneNumber': phoneNumber
      };
}
