import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rent/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;
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

  Future<void> ownerApproval(bool approval, String requestId) async {
    final collectionReference =
        FirebaseFirestore.instance.collection('request');
    final DocumentReference documentReference =
        collectionReference.doc(requestId);
    try {
      await documentReference.update({'approved': approval});
    } catch (e) {
      rethrow;
    }
  }

  final TextEditingController accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Requests"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('request')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final requests = snapshot.data!.docs;
          return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request['RequestedUser'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(request["contactNumber"]),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Material(
                                      elevation: 20,
                                      borderRadius: BorderRadius.circular(100),
                                      child: Bounceable(
                                        onTap: () =>
                                            makeCalls(request['contactNumber']),
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                              Icons.phone,
                                              size: 20,
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "I like to get your product ${request['ProductName']}"),
                              const SizedBox(height: 10),
                              const Text(
                                  "To make the payment you have to accept my request"),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // ownerApproval(true, request.id);
                                      showMaterialModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                child: SafeArea(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextWidget(
                                                            text:
                                                                "Please enter your payment details.This will be only asked in your first transaction",
                                                            size: 16),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      TextFieldWidget(
                                                        placeHolder:
                                                            "Enter Your bank account number",
                                                        controller:
                                                            accountController,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      const AccountBtn()
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ownerApproval(false, request.id);
                                    },
                                    child: const Text(
                                      "Decline",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
