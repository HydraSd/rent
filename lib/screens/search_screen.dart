import 'dart:convert';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rent/models/product.dart';
import 'package:rent/screens/screens.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final String header;
  final String search;
  const SearchScreen({super.key, required this.header, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // String _searchQuery = '';
  List<String>? _searchResults;
  LocationData? currentLocation;
  LatLng? destination;

  // void getCurrentLocation() async {
  //   Location location = Location();
  //   await location.getLocation().then((value) {
  //     setState(() {
  //       currentLocation = value;
  //     });
  //   });
  // }

  Future<List<String>> fetchData(String userSearch) async {
    final response =
        await http.get(Uri.parse("http://192.168.1.6:5000/$userSearch"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<String> list = data.cast<String>().toList();
      return list;
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
    _search();
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

  Future<void> _search() async {
    List<String> searchResults = await fetchData(widget.header);
    setState(() {
      _searchResults = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.header),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("test")
            .where('productName',
                whereIn:
                    _searchResults?.isNotEmpty == true ? _searchResults : [""])
            // .where('productName',
            //     whereIn: _searchResults?.isNotEmpty == true
            //         ? _searchResults
            //         : [""])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot product = snapshot.data!.docs[index];

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
                  subtitle: Text(product["category"]),
                  trailing: currentLocation != null &&
                          product['lat'] != null &&
                          product['long'] != null
                      ? Text(
                          "${calculateDistance(LatLng(currentLocation!.latitude!, currentLocation!.longitude!), LatLng(product['lat'], product['long'])).toStringAsFixed(2)} km",
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
                            price: product['price'],
                            weekEndPrice: product['weekendPrice'],
                            location: product['location'],
                            userID: product['userId'],
                            phoneNumber: product['phoneNumber'],
                          ))),
                );
              });
        },
      ),
    );
  }
}
