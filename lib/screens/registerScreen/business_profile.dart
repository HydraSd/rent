import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessProfile extends StatefulWidget {
  String userId;
  String name;
  String? imgUrl;
  String description;
  String phoneNumber;
  BusinessProfile({
    super.key,
    required this.userId,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.phoneNumber,
  });

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
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
          title: const Text("Profile"),
          titleTextStyle: Theme.of(context).textTheme.headline6,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                  onTap: () => makeCalls(widget.phoneNumber),
                  child: const Icon(Icons.phone)),
            )
          ]),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (widget.imgUrl != null && widget.imgUrl!.isNotEmpty)
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.imgUrl!),
                            fit: BoxFit.cover)),
                  ),
                if (widget.imgUrl == null || widget.imgUrl!.isEmpty)
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
                  widget.name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 4, top: 20),
            child: Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('test')
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
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
                                    price: convertPrice(product['price']),
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
          ),
        )
      ]),
    );
  }
}
