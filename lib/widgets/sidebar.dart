import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  String? documentId;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<DocumentSnapshot<Object?>?> getProfile() async {
    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('userId', isEqualTo: widget.userId)
        .limit(1)
        .get();

    DocumentSnapshot<Object?>? documentSnapshot;

    // DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance
    //     .collection('userProfile')
    //     .where('userId', isEqualTo: widget.userId)
    //     .limit(1)
    //     .get()
    //     .then((querySnapshot) => querySnapshot.docs.first);

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Object?> documentSnapshot = querySnapshot.docs.first;
      if (documentSnapshot != null) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          businessName = data!['businessName'];
          imgUrl = data["logoUrl"];
          description = data["description"];
          phoneNumber = data["phoneNumber"];
          documentId = documentSnapshot.id;
        });
      }

      return documentSnapshot;
    }
    return null;
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
                      documentId: documentId!,
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
      ]),
    );
  }
}
