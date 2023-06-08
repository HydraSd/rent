import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';
import 'package:rent/screens/rent_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatelessWidget {
  String userId;
  String name;
  String? imgUrl;
  String description;
  String phoneNumber;

  StoreScreen(
      {super.key,
      required this.userId,
      required this.name,
      this.imgUrl = '',
      required this.phoneNumber,
      required this.description});

  @override
  Widget build(BuildContext context) {
    void makeCalls(String phoneNumber) async {
      if (await canLaunchUrl(Uri.parse("tel:$phoneNumber"))) {
        await launchUrl(Uri.parse("tel:$phoneNumber"));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occured with $phoneNumber'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("Your Store"),
          titleTextStyle: Theme.of(context).textTheme.headline6,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                  // onTap: () => makeCalls(widget.phoneNumber),
                  child: const Icon(Icons.phone)),
            )
          ]),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  if (imgUrl != null && imgUrl!.isNotEmpty)
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(imgUrl!), fit: BoxFit.cover)),
                    ),
                  if (imgUrl == null || imgUrl!.isEmpty)
                    Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey, // Change color as needed
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white, // Change color as needed
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    phoneNumber,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Your products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('test')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot document =
                            snapshot.data!.docs[index];
                        final Map<String, dynamic>? product =
                            document.data() as Map<String, dynamic>?;
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        documentId: '',
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
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${product!['imgUrl'][0]}"))),
                            ),
                            title: Text(product['productName']),
                            subtitle: Text(product['category']),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ]),
          ),
          SliverToBoxAdapter(
              child: TextButton(
            child: const Text("Add a product"),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RentScreen()));
            },
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4, top: 20),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
