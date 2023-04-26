import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent/models/product.dart';
import 'package:rent/screens/direction_screen.dart';
import 'package:rent/widgets/pirces.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviewScreen extends StatefulWidget {
  final List<File> images;
  final String productName;
  final String description;
  final String catagory;
  final String price;
  final String weekendPrice;
  final double lat;
  final double long;
  final String location;
  final String phoneNumber;

  const PreviewScreen(
      {super.key,
      required this.images,
      required this.productName,
      required this.description,
      required this.catagory,
      required this.price,
      required this.weekendPrice,
      required this.lat,
      required this.long,
      required this.location,
      required this.phoneNumber});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;

  String _getuserId() {
    String userId = user!.uid;
    return userId;
  }

  Future<void> rentProduct() async {
    setState(() {
      isLoading = true;
    });
    List<String> urls = [];

    for (int i = 0; i < widget.images.length; i++) {
      File image = widget.images[i];
      String imageName = '${DateTime.now().microsecondsSinceEpoch}_$i.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(imageName);
      await ref.putFile(image);
      String imgUrl = await ref.getDownloadURL();
      urls.add(imgUrl);
    }
    final doc = FirebaseFirestore.instance.collection('test').doc();
    final product = Product(
        imgUrl: urls,
        productName: widget.productName,
        catagory: widget.catagory,
        description: widget.description,
        price: widget.price,
        weekendPrice: widget.weekendPrice,
        userID: _getuserId(),
        lat: widget.lat,
        long: widget.long,
        location: widget.location,
        phoneNumber: widget.phoneNumber);
    final json = product.toJson();
    await doc.set(json);
    setState(() {
      isLoading = false;
    });
  }

  void makeCalls(String phoneNumber) async {
    String telUrl = 'tel:0705980290';
    if (await canLaunchUrl(Uri.parse(telUrl))) {
      await launchUrl(Uri.parse(telUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $telUrl'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Confirm your Product",
        ),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => makeCalls(widget.phoneNumber),
      //   tooltip: "call",
      //   child: const Icon(Icons.phone),
      // ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: _ImageSlider(images: widget.images),
        ),
        SliverToBoxAdapter(
          child: _Content(
              lat: widget.lat,
              long: widget.long,
              location: widget.location,
              price: widget.price,
              weekendPrice: widget.weekendPrice,
              catagory: widget.catagory,
              productName: widget.productName,
              description: widget.description),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Bounceable(
                      onTap: () async {
                        await confimation(context);
                      },
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
                            "Publish",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
            ),
          ),
        )
      ]),
    );
  }

  confimation(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text("Publish confirmation"),
            content: Text(
                "By confirming this you will publish your ${widget.productName} to store under the catagory of ${widget.catagory}"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context, "Cancel"),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    await rentProduct();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, "Cancel");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Theme.of(context).cardColor,
                            title: const Text("Details"),
                            content: const Text(
                                "Your product published successfully"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, "Cancel");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  },
                                  child: const Text("Ok"))
                            ],
                          );
                        });
                  },
                  child: const Text("Confirm"))
            ],
          );
        });
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {Key? key,
      required this.productName,
      required this.description,
      required this.catagory,
      required this.price,
      required this.weekendPrice,
      required this.location,
      required this.lat,
      required this.long})
      : super(key: key);

  final String productName;
  final String description;
  final String catagory;
  final String price;
  final String weekendPrice;
  final double lat;
  final double long;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const Text(
            "ratings would be added here",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Catagory product belongs: $catagory",
                style: const TextStyle(fontSize: 16)),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Prices(
                price: price,
                weekendPrice: weekendPrice,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DirectionScreen(
                            lat: lat,
                            long: long,
                          )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Expanded(child: Icon(Icons.location_on)),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSlider extends StatelessWidget {
  const _ImageSlider({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<File> images;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: CarouselSlider(
          options: CarouselOptions(
              height: 400, autoPlay: true, enlargeCenterPage: true),
          items: images.map((image) {
            return Container(
              height: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(image), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20)),
            );
          }).toList()),
    );
  }
}
