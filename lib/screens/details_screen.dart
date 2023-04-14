import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/screens/screens.dart';
import 'package:rent/widgets/pirces.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailsScreen extends StatefulWidget {
  final List<dynamic> imgurls;
  final String productName;
  final String catagory;
  final String description;
  final String price;
  final String weekEndPrice;
  final String location;
  final double lat;
  final double long;
  final String userID;
  final String documentId;
  const DetailsScreen(
      {super.key,
      required this.imgurls,
      required this.productName,
      required this.catagory,
      required this.description,
      required this.price,
      required this.weekEndPrice,
      required this.location,
      required this.lat,
      required this.long,
      required this.userID,
      required this.documentId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String getUserId() {
      String userId = user!.uid;
      return userId;
    }

    DateTimeRange selectedDates =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    List<String> imgUrlsStr = widget.imgurls.map((e) => e.toString()).toList();

    Future<void> deleteFile(String url) async {
      try {
        final Reference ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
        print('File deleted: $url');
      } catch (e) {
        print('Error deleting file: $e');
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
        print('Document and files deleted');
      } catch (e) {
        print('Error deleting document and files: $e');
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
                  "Bu clicking confirm you will delete your product ${widget.productName}"),
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ImageScroller(
              imagUrls: widget.imgurls,
            ),
          ),
          SliverToBoxAdapter(
            child: _Title(
              lat: widget.lat,
              long: widget.long,
              location: widget.location,
              price: widget.price,
              weekEndPrice: widget.weekEndPrice,
              productName: widget.productName,
              catagory: widget.catagory,
              description: widget.description,
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Center(
                child: TextButton(
              onPressed: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_month_outlined),
                    SizedBox(width: 10),
                    Text("Choose date")
                  ]),
            )),
          ),
          SliverToBoxAdapter(
            child: _Content(
              lat: widget.lat,
              location: widget.location,
              long: widget.long,
              description: widget.description,
            ),
          ),
          SliverToBoxAdapter(
            child: (getUserId() == widget.userID)
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 4),
                        child: Bounceable(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateScreen(
                                      documentId: widget.documentId,
                                      productName: widget.productName,
                                      price: widget.price,
                                      description: widget.description,
                                    )));
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
                                "Update product",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                      ),
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Bounceable(
                      onTap: () {},
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
                            "Get product",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.lat,
    required this.long,
    required this.location,
    required this.description,
  }) : super(key: key);

  final double lat;
  final double long;
  final String location;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        const SizedBox(height: 10)
      ]),
    );
  }
}

class _Title extends StatelessWidget {
  final String productName;
  final String catagory;
  final String description;
  final String price;
  final String weekEndPrice;
  final double lat;
  final double long;

  final String location;
  const _Title(
      {required this.productName,
      required this.catagory,
      required this.description,
      required this.price,
      required this.weekEndPrice,
      required this.location,
      required this.lat,
      required this.long});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Row(
            children: const [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("Catagory product belongs: $catagory",
                style: const TextStyle(fontSize: 16)),
          ),
          Prices(price: price, weekendPrice: weekEndPrice),
        ],
      ),
    );
  }
}

class _ImageScroller extends StatelessWidget {
  final List<dynamic> imagUrls;

  const _ImageScroller({super.key, required this.imagUrls});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 400,
          autoPlay: true,
          // autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
        ),
        items: imagUrls.map((image) {
          return Container(
            width: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          );
        }).toList(),
      ),
    );
  }
}
