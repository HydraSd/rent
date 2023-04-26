import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/screens/screens.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rent/screens/user_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rent/widgets/widget.dart';

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
  final String phoneNumber;
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
      required this.documentId,
      required this.phoneNumber});

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
            child: Title1(
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
          SliverToBoxAdapter(
            child: Center(
                child: TextButton(
              onPressed: () async {
                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (dateTimeRange != null) {
                  final DateTime startDate = dateTimeRange.start;
                  final DateTime endDate = dateTimeRange.end;
                  print("$startDate to $endDate");
                }
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
            child: Content(
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
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserDetailsScreen())),
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
                            "Get",
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
