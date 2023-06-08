import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/models/saved.dart';
import 'package:rent/screens/registerScreen/business_profile.dart';
import 'package:rent/screens/screens.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rent/screens/user_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rent/widgets/widget.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  final List<dynamic> imgurls;
  final String productName;
  final String catagory;
  final String description;
  final String price;
  final String location;
  final double lat;
  final double long;
  final String userID;
  final String documentId;
  final int request;
  final String phoneNumber;

  const DetailsScreen({
    super.key,
    required this.imgurls,
    required this.productName,
    required this.catagory,
    required this.description,
    required this.price,
    required this.location,
    required this.lat,
    required this.long,
    required this.userID,
    required this.documentId,
    required this.phoneNumber,
    required this.request,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool product = true;
  bool supplier = false;

  User? user = FirebaseAuth.instance.currentUser;

  String? businessName;
  String? imgUrl;
  String? description;
  String? phoneNumber;

  void addProductToUserDocument(String userId, String newProductId) {
    FirebaseFirestore.instance
        .collection('userDetails')
        .where('userId', isEqualTo: widget.userID)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        String documentId = querySnapshot.docs[0].id;
        List<dynamic> productList = querySnapshot.docs[0].get('products');
        productList.add(newProductId);

        // Update the user document with the updated product list
        FirebaseFirestore.instance
            .collection('userDetails')
            .doc(documentId)
            .update({'products': productList}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('product saved successfully'),
            backgroundColor: Colors.green,
          ));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } else {
        // User document does not exist, create a new document
        FirebaseFirestore.instance.collection('userDetails').add({
          'userId': userId,
          'products': [newProductId],
        }).then((documentRef) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('product saved successfully'),
            backgroundColor: Colors.green,
          ));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<QuerySnapshot<Object?>>? getProfile() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('userId', isEqualTo: widget.userID)
        .get();

    if (querySnapshot != null) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          businessName = data!['businessName'];
          imgUrl = data["logoUrl"];
          description = data["description"];
          phoneNumber = data["phoneNumber"];
        });
      }
    }
    // print(businessName);
    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String getUserId() {
      String userId = user!.uid;
      return userId;
    }

    List<String> imgUrlsStr = widget.imgurls.map((e) => e.toString()).toList();

    Future<void> deleteFile(String url) async {
      try {
        final Reference ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      } catch (e) {
        rethrow;
      }
    }

    Future<void> deleteDocument(String documentID, List<String> imgUrls) async {
      final CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('test');
      final DocumentReference documentReference =
          collectionReference.doc(documentID);
      try {
        await documentReference.delete();
        for (String imgUrl in widget.imgurls) {
          await deleteFile(imgUrl);
        }
      } catch (e) {
        rethrow;
      }
    }

    delete(BuildContext context) async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("Delete confirmation"),
              content: Text(
                  "Buy clicking confirm you will delete your product ${widget.productName}"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      deleteDocument(widget.documentId, imgUrlsStr);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                    child: const Text("Confirm"))
              ],
            );
          });
    }

    void makeCalls(String phoneNumber) async {
      String telUrl = 'tel:0705980290';
      if (await canLaunchUrl(Uri.parse("tel:$phoneNumber"))) {
        await launchUrl(Uri.parse("tel:$phoneNumber"));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $phoneNumber'),
          ),
        );
      }
    }

    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: const Icon(Icons.arrow_back)),
        title: const Text("Details"),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
                onTap: () => makeCalls(widget.phoneNumber),
                child: const Icon(Icons.phone)),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ImageScroller(
              imagUrls: widget.imgurls,
            ),
          ),
          SliverToBoxAdapter(
            child: Row(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: product ? 20 : 0,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        product = true;
                        supplier = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: product
                              ? (brightness == Brightness.light)
                                  ? const Color.fromARGB(255, 189, 188, 188)
                                  : Colors.white
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "Product",
                          style: TextStyle(
                              color: product
                                  ? (brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black)
                                  : (brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: supplier ? 20 : 0,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        product = false;
                        supplier = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: supplier
                              ? (brightness == Brightness.light)
                                  ? const Color.fromARGB(255, 189, 188, 188)
                                  : Colors.white
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "Supplier",
                          style: TextStyle(
                              color: supplier
                                  ? Colors.black
                                  : (brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
            ]),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: product,
              child: Title1(
                lat: widget.lat,
                long: widget.long,
                location: widget.location,
                price: widget.price,
                productName: widget.productName,
                catagory: widget.catagory,
                description: widget.description,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: product,
              child: Content(
                lat: widget.lat,
                location: widget.location,
                long: widget.long,
                description: widget.description,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
                visible: supplier,
                child: Column(
                  children: [
                    ListTile(
                      leading: (imgUrl != null)
                          ? Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imgUrl!))),
                            )
                          : null,
                      title:
                          (businessName != null) ? Text(businessName!) : null,
                      subtitle:
                          (phoneNumber != null) ? Text(phoneNumber!) : null,
                      trailing: GestureDetector(
                        onTap: () => makeCalls(phoneNumber!),
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                            child: const Icon(Icons.phone)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BusinessProfile(
                                      userId: '',
                                      name: businessName!,
                                      imgUrl: imgUrl,
                                      description: description!,
                                      phoneNumber: phoneNumber!))),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue),
                              child: const Center(
                                  child: Text(
                                "View profile",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ))
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: product,
              child: (getUserId() == widget.userID)
                  ? Column(
                      children: [
                        UpdateProduct(
                            documentId: widget.documentId,
                            price: widget.price,
                            productName: widget.productName,
                            description: widget.description),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 4),
                          child: Bounceable(
                            onTap: () async {
                              await delete(context);
                            },
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent),
                                child: const Center(
                                    child: Text(
                                  "Delete product",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  : Bounceable(
                      onTap: () {
                        addProductToUserDocument(user!.uid, widget.documentId);
                      },
                      child: const RequestBtn(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
