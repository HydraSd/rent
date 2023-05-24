import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';

class Catagories extends StatelessWidget {
  final String catagory;
  final String des;
  const Catagories({super.key, required this.catagory, required this.des});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        // elevation: 0,
        // backgroundColor: Colors.transparent,
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
        title: Text(catagory),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text(
              des,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("test")
                  .where('category', isEqualTo: catagory)
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
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
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
                                    request: product['requests'],
                                  ))),
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage("${product['imgUrl'][0]}"))),
                        ),
                        title: Text(product['productName']),
                        subtitle: Text(product['category']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
