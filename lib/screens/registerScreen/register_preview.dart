import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/models/register.dart';
import 'package:rent/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePreview extends StatefulWidget {
  final String name;
  final List<File>? images;
  final String phoneNumber;
  final String description;

  const UserProfilePreview(
      {super.key,
      required this.name,
      this.images,
      required this.phoneNumber,
      required this.description});

  @override
  State<UserProfilePreview> createState() => _UserProfilePreviewState();
}

class _UserProfilePreviewState extends State<UserProfilePreview> {
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

    bool isLoading = false;
    User? user = FirebaseAuth.instance.currentUser;
    String imageUrl = '';

    String getuserId() {
      String userId = user!.uid;
      return userId;
    }

    Future<void> publishProfile() async {
      setState(() {
        isLoading = true;
      });
      if (widget.images != null && widget.images!.isNotEmpty) {
        File image = widget.images![0];
        String imageName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(imageName);
        await ref.putFile(image);
        String imgUrl = await ref.getDownloadURL();
        setState(() {
          imageUrl = imgUrl;
        });
      }

      final doc = FirebaseFirestore.instance.collection('userProfile').doc();

      final profile = Register(
        userId: getuserId(),
        phoneNumber: widget.phoneNumber,
        businessName: widget.name,
        logoUrl: imageUrl,
        description: widget.description,
      );
      final json = profile.toJson();
      await doc.set(json);
      setState(() {
        isLoading = false;
      });
    }

    confirmation(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: const Text("Confirmation"),
              content: Text(
                  "By confirming your going to publish your account ${widget.name} "),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, "Cancel");
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      await publishProfile();
                      Navigator.pop(context, "Cancel");

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Theme.of(context).cardColor,
                              content: const Text(
                                  "Your account published successfully"),
                              actions: [
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        title: const Text("User profile"),
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
            child: Center(
              child: Column(
                children: [
                  if (widget.images != null && widget.images!.isNotEmpty)
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(widget.images![0]),
                              fit: BoxFit.cover)),
                    ),
                  if (widget.images == null || widget.images!.isEmpty)
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
          const SliverToBoxAdapter(
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Your products will be shown here",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            )),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Bounceable(
                onTap: () {
                  confirmation(context);
                },
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "Publish",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
