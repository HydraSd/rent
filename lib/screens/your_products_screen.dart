import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent/screens/details_screen.dart';
import 'package:rent/screens/home_screen.dart';

class YourProducts extends StatefulWidget {
  const YourProducts({super.key});

  @override
  State<YourProducts> createState() => _YourProductsState();
}

class _YourProductsState extends State<YourProducts> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen())),
            child: const Icon(Icons.arrow_back)),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Your Products"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("test")
            .where('userId', isEqualTo: user?.uid)
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
                              // weekEndPrice: product['weekendPrice'],
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
                            image: NetworkImage("${product['imgUrl'][0]}"))),
                  ),
                  title: Text(product['productName']),
                  subtitle: Text(product['category']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
