import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rent/productScreen/popular_screen.dart';
import 'package:rent/screens/details_screen.dart';
import 'package:rent/widgets/popular_card.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;

class MostPopularWid extends StatefulWidget {
  const MostPopularWid({super.key});

  @override
  State<MostPopularWid> createState() => MostPopularWidState();
}

class MostPopularWidState extends State<MostPopularWid> {
  List? topProducts;
  Future<List<Map<String, dynamic>>> getTopRequested() async {
    CollectionReference productsRef =
        FirebaseFirestore.instance.collection('test');
    QuerySnapshot topProductsSnapshot =
        await productsRef.orderBy('requests', descending: true).limit(10).get();

    List<Map<String, dynamic>> topProductsData = [];
    for (DocumentSnapshot productSnapshot in topProductsSnapshot.docs) {
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;
      productData['id'] = productSnapshot.id;
      topProductsData.add(productData);
    }
    List<Map<String, dynamic>> topTenProductsData =
        topProductsData.take(10).toList();
    setState(() {
      topProducts = topTenProductsData;
    });
    return topTenProductsData;
  }

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double radius = 6371; // Earth's radius in kilometers
    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
    getTopRequested();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Text(
                "Most Popular",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PopularProductScreen()));
                },
                child: const Icon(Icons.arrow_forward))
          ],
        ),
        SizedBox(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topProducts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final product = topProducts![index];

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                              documentId: product['id'],
                              lat: product['lat'],
                              long: product['long'],
                              imgurls: product["imgUrl"],
                              productName: product["productName"],
                              catagory: product["category"],
                              description: product["description"],
                              price: product['price'],
                              location: product['location'],
                              userID: product['userId'],
                              phoneNumber: product['phoneNumber'],
                              request: product['requests'],
                            ))),
                    child: MostPopular(
                      // distance:
                      //     "${calculateDistance(LatLng(currentLocation!.latitude!, currentLocation!.longitude!), LatLng(product['lat'], product['long'])).toStringAsFixed(2)} km",
                      productName: product["productName"],
                      imgURL: product["imgUrl"][0],
                    ),
                  );
                })),
      ],
    );
  }
}
