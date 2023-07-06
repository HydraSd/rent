import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/details_screen.dart';
import 'package:rent/screens/home_screen.dart';
import 'package:rent/screens/registerScreen/update_screen.dart';
import 'package:rent/screens/rent_screen.dart';
import 'package:rent/widgets/requestBtn.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class StoreScreen extends StatefulWidget {
  String userId;
  String name;
  String? imgUrl;
  String description;
  String phoneNumber;
  String documentId;
  StoreScreen(
      {super.key,
      required this.userId,
      required this.name,
      this.imgUrl = '',
      required this.documentId,
      required this.phoneNumber,
      required this.description});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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

    Future<void> deleteFile(String url) async {
      try {
        final Reference ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      } catch (e) {
        rethrow;
      }
    }

    Future<void> deleteDocument(String documentID, String imgUrls) async {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('userProfile');
      final DocumentReference documentReference =
          collectionReference.doc(documentID);
      try {
        await documentReference.delete();
        deleteFile(widget.imgUrl!);
      } catch (e) {
        rethrow;
      }
    }

    delete(BuildContext context) async {
      print(widget.documentId);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("Delete confirmation"),
              content: Text(
                  "Buy clicking confirm you will delete your  ${widget.name} account"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      deleteDocument(widget.documentId, widget.imgUrl!);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                    child: const Text("Confirm"))
              ],
            );
          });
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
          title: const Text("Your Store"),
          titleTextStyle: Theme.of(context).textTheme.headline6,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                  onTap: () => makeCalls(widget.phoneNumber),
                  child: const Icon(Icons.phone)),
            )
          ]),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
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
              )
            ]),
          ),
          SliverToBoxAdapter(
              child: TextButton(
            child: const Text("Add a product"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RentScreen()));
            },
          )),
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
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateBusinessProfile(
                            businessName: widget.name,
                            phoneNumber: widget.phoneNumber,
                            imgUrl: widget.imgUrl!,
                            description: widget.description,
                            documentId: widget.documentId,
                          ))),
                  child: const RequestBtn(
                    btnText: "Update Profile",
                    paddingbottom: 10,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    delete(context);
                  },
                  child: const RequestBtn(
                    btnText: "Delete Profile",
                    btnColor: Colors.redAccent,
                    paddingTop: 0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
