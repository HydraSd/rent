import 'package:flutter/material.dart';

class BusinessProfile extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                  // onTap: () => makeCalls(widget.phoneNumber),
                  child: const Icon(Icons.phone)),
            )
          ]),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (imgUrl != null && imgUrl!.isNotEmpty)
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(imgUrl!), fit: BoxFit.cover)),
                  ),
                if (imgUrl == null || imgUrl!.isEmpty)
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
                  name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  phoneNumber,
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
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ]),
    );
  }
}
