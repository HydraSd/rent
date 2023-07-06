import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';

class SavedProductsScreen extends StatelessWidget {
  String userId;
  SavedProductsScreen({super.key, required this.userId});

  Future<List<DocumentSnapshot>> _fetchProductDetails(
      List<String> productIds) async {
    final List<DocumentSnapshot> productDetails = [];

    for (final productId in productIds) {
      final snapshot = await FirebaseFirestore.instance
          .collection("test")
          .doc(productId)
          .get();

      if (snapshot.exists) {
        productDetails.add(snapshot);
      }
    }

    return productDetails;
  }

  @override
  Widget build(BuildContext context) {
    double convertPrice(dynamic price) {
      if (price is int) {
        return price.toDouble();
      } else if (price is double) {
        return price;
      } else {
        return 0.0; // Return a default value if the price is not a valid number.
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("Saved products"),
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("userDetails")
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final products = snapshot.data!.docs;
            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final productIds = List<String>.from(product["products"]);

                  return FutureBuilder<List<DocumentSnapshot>>(
                      future: _fetchProductDetails(productIds),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final productDetails = snapshot.data!;

                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                              itemCount: productDetails.length,
                              itemBuilder: (context, index) {
                                final documentSnapshot = productDetails[index];

                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                                documentId: documentSnapshot.id,
                                                lat: documentSnapshot['lat'],
                                                long: documentSnapshot['long'],
                                                imgurls:
                                                    documentSnapshot["imgUrl"],
                                                productName: documentSnapshot[
                                                    "productName"],
                                                catagory: documentSnapshot[
                                                    "category"],
                                                description: documentSnapshot[
                                                    "description"],
                                                price: convertPrice(
                                                    documentSnapshot['price']),
                                                // weekEndPrice: product['weekendPrice'],
                                                location: documentSnapshot[
                                                    'location'],
                                                userID:
                                                    documentSnapshot['userId'],
                                                phoneNumber: documentSnapshot[
                                                    'phoneNumber'],
                                                request: documentSnapshot[
                                                    'requests'],
                                              ))),
                                  child: ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "${documentSnapshot['imgUrl'][0]}"))),
                                    ),
                                    title: Text(
                                        '${documentSnapshot['productName']}'),
                                    subtitle:
                                        Text(documentSnapshot['location']),
                                  ),
                                );
                              }),
                        );
                      });
                });
          },
        ));
  }
}
