import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent/screens/notification_screen.dart';
import 'package:rent/screens/productScreen/saved_screen.dart';
import 'package:rent/screens/registerScreen/register_screen.dart';
import 'package:rent/screens/registerScreen/storeScreen.dart';
import 'package:rent/screens/screens.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.name, required this.userId});
  final String name;
  final String userId;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? businessName;
  String? imgUrl;
  String? phoneNumber;
  String? description;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<QuerySnapshot<Object?>>? getProfile() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('userId', isEqualTo: widget.userId)
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
    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: Column(children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Hello, ${widget.name}",
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
          child: const ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        if (businessName == null)
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RegisterScreen())),
            child: const ListTile(
              leading: Icon(Icons.app_registration),
              title: Text(
                "Register as a seller",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        if (businessName != null)
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StoreScreen(
                      userId: widget.userId,
                      imgUrl: imgUrl,
                      name: businessName!,
                      description: description!,
                      phoneNumber: phoneNumber!,
                    ))),
            child: const ListTile(
              leading: Icon(Icons.store),
              title: Text(
                "Your Store",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        if (businessName != null)
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RentScreen())),
            child: const ListTile(
              leading: Icon(Icons.sell_outlined),
              title: Text(
                "Sell a product",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SavedProductsScreen(
                    userId: widget.userId,
                  ))),
          child: const ListTile(
            leading: Icon(Icons.save),
            title: Text(
              "Saved products",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NotificationScreen())),
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text(
              "Notification",
              style: TextStyle(fontSize: 16),
            ),
            trailing: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child: const Text(
                  "1",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
