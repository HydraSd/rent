import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';

class PopularProductScreen extends StatelessWidget {
  const PopularProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text("Most popular products"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('test')
            .orderBy('requests', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Sorry, something went wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            documentId: document.id,
                            lat: data['lat'],
                            long: data['long'],
                            imgurls: data["imgUrl"],
                            productName: data["productName"],
                            catagory: data["category"],
                            description: data["description"],
                            price: data['price'],
                            location: data['location'],
                            userID: data['userId'],
                            phoneNumber: data['phoneNumber'],
                            request: data['requests'],
                          )));
                },
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${data['imgUrl'][0]}"))),
                  ),
                  title: Text(data['productName']),
                  subtitle: Text(data['category']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
