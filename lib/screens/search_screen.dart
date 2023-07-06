import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rent/models/product_distance.dart';
import 'package:rent/screens/screens.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class SearchScreen extends StatefulWidget {
  final String header;
  final String search;
  const SearchScreen({super.key, required this.header, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // String _searchQuery = '';

  LocationData? currentLocation;
  LatLng? destination;

  void getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
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

  bool filter = false;

  double convertPrice(dynamic price) {
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else {
      return 0.0; // Return a default value if the price is not a valid number.
    }
  }

  var startPrice = MoneyMaskedTextController(
    decimalSeparator: '.', // Set the decimal separator character
    thousandSeparator: ',', // Set the thousand separator character
    leftSymbol: '\Rs', // Set the currency symbol or any other desired symbol
  );

  var endPrice = MoneyMaskedTextController(
    decimalSeparator: '.', // Set the decimal separator character
    thousandSeparator: ',', // Set the thousand separator character
    leftSymbol: '\Rs', // Set the currency symbol or any other desired symbol
  );
  @override
  void dispose() {
    startPrice.dispose();
    endPrice.dispose();
    super.dispose();
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
        title: Text(widget.header),
        titleTextStyle: Theme.of(context).textTheme.headline6,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    filter = !filter;
                  });
                },
                child: const Icon(Icons.filter_list_outlined)),
          )
        ],
        bottom: filter
            ? PreferredSize(
                preferredSize: const Size(double.maxFinite, 150),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filter Data",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Text("Price: ${startPrice.text} - ${endPrice.text}"),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: startPrice,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Starting price",
                                  prefixIcon: Icon(Icons.attach_money),
                                ),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: endPrice,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Ending price",
                                  prefixIcon: Icon(Icons.attach_money),
                                ),
                              ),
                            ))
                          ],
                        )
                      ]),
                ),
              )
            : null,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("test").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final searchQuery = widget.search.toLowerCase();
          final searchResults = snapshot.data!.docs.where((doc) {
            final productName = doc['productName'].toString().toLowerCase();
            final productPrice = doc['price'] ?? 0.0;
            startPrice.addListener(updateUI);
            endPrice.addListener(updateUI);

            double amount = startPrice.numberValue;
            double amount2 = (endPrice.numberValue == 0)
                ? double.infinity
                : endPrice.numberValue;
            print(amount2);
            return productName.contains(searchQuery) &&
                productPrice >= amount &&
                productPrice <= amount2;
            // return productName.contains(searchQuery);
          }).toList();

          LatLng? currentLatLng;
          if (currentLocation != null) {
            currentLatLng = LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            );
          }
          List<ProductDistance> products = [];

          for (DocumentSnapshot product in searchResults) {
            double distance = 0;

            if (currentLocation != null &&
                product['lat'] != null &&
                product['long'] != null) {
              LatLng productLatLng = LatLng(product['lat'], product['long']);
              distance = calculateDistance(currentLatLng!, productLatLng);
            }

            products.add(ProductDistance(product, distance));
          }

          products.sort((a, b) => a.distance.compareTo(b.distance));

          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                DocumentSnapshot product = products[index].product;

                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${product['imgUrl'][0]}"))),
                  ),
                  title: Text(product["productName"]),
                  subtitle: Text(
                    product["location"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: currentLocation != null &&
                          product['lat'] != null &&
                          product['long'] != null
                      ? Text(
                          "${calculateDistance(currentLatLng!, LatLng(product['lat'], product['long'])).toStringAsFixed(2)} km",
                          style: const TextStyle(color: Colors.blue),
                        )
                      : null,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            documentId: product.id,
                            lat: product['lat'],
                            long: product['long'],
                            imgurls: product["imgUrl"],
                            productName: product["productName"],
                            catagory: product["category"],
                            description: product["description"],
                            price: convertPrice(product['price']),
                            location: product['location'],
                            userID: product['userId'],
                            phoneNumber: product['phoneNumber'],
                            request: product['requests'],
                          ))),
                );
              });
        },
      ),
    );
  }
}
