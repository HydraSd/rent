import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent/func/google_sign_in.dart';
import 'package:rent/models/product.dart';
import 'package:rent/screens/catagories_screen.dart';
import '../screens/screens.dart';
import 'package:rent/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
          drawer: SideBar(
            name: "${user.displayName}",
          ),
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("RentMate",
                  style: (brightness == Brightness.light)
                      ? const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)
                      : const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 18.0,
                  top: 8,
                ),
                child: _SignOutButton(user: user),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchScreen(
                                    header: _searchController.text,
                                    search: "search")));
                            // hadleSearch(_searchController.text);
                          },
                          child: Icon(
                            Icons.search,
                            color: (brightness == Brightness.light)
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                        hintText: "Search here",
                        border: InputBorder.none),
                    onSubmitted: (value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen(
                              header: _searchController.text,
                              search: "search")));
                    },
                  ),
                ),
              ),
            ),
          ),
          // body: _Catagories(),
          body: const _UnfocusMode()),
    );
  }
}

class _UnfocusMode extends StatelessWidget {
  const _UnfocusMode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Catagories()),
        SliverToBoxAdapter(child: _MostPopular()),
        SliverToBoxAdapter(child: _Recommended()),
      ],
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                title: const Text("Signout"),
                content: Text("Confirme to signout from ${user.email}"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, "Cancel"),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.logout();
                        Navigator.pop(context, "Cancel");
                      },
                      child: const Text("Confirm"))
                ],
              );
            }),
        child: Avatar(image: "${user.photoURL}"));
  }
}

class _Catagories extends StatelessWidget {
  _Catagories({
    Key? key,
  }) : super(key: key);

  final List<Map<String, String>> catagoryData = [
    {
      'name': "Electronics",
      'description':
          'This category include items like laptops, projectors, cameras, and other electronic devices.',
      'image': 'assets/images/electronic.png',
    },
    {
      'name': 'Home appliance',
      'description':
          "This category include items like air conditioners, refrigerators, washing machines, and other appliances.",
      'image': "assets/images/home-appliance.png"
    },
    {
      "name": "Furniture",
      "description":
          "This category include items like beds, sofas, chairs, tables, and other furniture pieces.",
      "image": "assets/images/furnitures.png"
    },
    {
      'name': "Sports and Fitness",
      'description':
          "This category include items like bicycles, gym equipment, sports gear, and other fitness-related items.",
      'image': "assets/images/fitness.png"
    },
    {
      'name': "Tools and Equipment",
      'description':
          "This category can include items like power tools, hand tools, and other equipment for construction, home repairs, and other projects.",
      'image': "assets/images/toolbox.png"
    },
    {
      'name': "Clothing and Accessories",
      'description':
          "This category can include items like formal wear, costumes, and accessories that are often rented for special events.",
      'image': "assets/images/handbag.png"
    },
    {
      'name': "Party and Event",
      'description':
          "This category can include items like party decorations, sound systems, lighting equipment, and other items that are often rented for events.",
      'image': "assets/images/people.png"
    },
    {
      'name': "Camping and Outdoors",
      'description':
          "This category can include items like tents, sleeping bags, and other camping gear.",
      'image': "assets/images/tent.png"
    },
    {
      'name': "Vehicles",
      'description':
          "This category can include items like bicycles, scooters, and cars that are often rented for short periods of time.",
      'image': "assets/images/car.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderTitles(
          title: "Categories",
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catagoryData.length,
              itemBuilder: (context, index) {
                final category = catagoryData[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Catagories(
                          catagory: category['name'].toString(),
                          des: category['description'].toString()))),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CatagoryBox(
                        name: category['name'].toString(),
                        url: category['image'].toString(),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _MostPopular extends StatefulWidget {
  const _MostPopular();

  @override
  State<_MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<_MostPopular> {
  List? topProducts;
  Future<List<Map<String, dynamic>>> getTopRequested() async {
    CollectionReference productsRef =
        FirebaseFirestore.instance.collection('test');
    QuerySnapshot topProductsSnapshot =
        await productsRef.orderBy('requests', descending: true).limit(10).get();

    List<Map<String, dynamic>> topProductsData = [];
    for (DocumentSnapshot productSnapshot in topProductsSnapshot.docs) {
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;
      topProductsData.add(productData);
    }
    List<Map<String, dynamic>> topTenProductsData =
        topProductsData.take(10).toList();
    setState(() {
      topProducts = topTenProductsData;
    });
    return topTenProductsData;
  }

  @override
  void initState() {
    super.initState();
    getTopRequested();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderTitles(title: "Most popular"),
        SizedBox(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topProducts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var product = topProducts![index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                              documentId: '',
                              lat: product['lat'],
                              long: product['long'],
                              imgurls: product["imgUrl"],
                              productName: product["productName"],
                              catagory: product["category"],
                              description: product["description"],
                              price: product['price'],
                              weekEndPrice: product['weekendPrice'],
                              location: product['location'],
                              userID: product['userId'],
                              phoneNumber: product['phoneNumber'],
                              request: product['requests'],
                            ))),
                    child: MostPopular(
                      productName: product["productName"],
                      imgURL: product["imgUrl"][0],
                    ),
                  );
                })),
      ],
    );
  }
}

class _Recommended extends StatelessWidget {
  const _Recommended();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderTitles(title: "Recommended"),
        SizedBox(
          height: 250,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            MostPopular(),
            MostPopular(),
            MostPopular(),
            MostPopular(),
          ]),
        ),
      ],
    );
  }
}
