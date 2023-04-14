import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent/func/google_sign_in.dart';
import '../screens/screens.dart';
import 'package:rent/widgets/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final List<String> items = [
    'Item 12',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    "Items test"
  ];

  @override
  Widget build(BuildContext context) {
    // void hadleSearch(String query) {
    //   if (query.isNotEmpty) {
    //     showSearch(
    //         context: context,
    //         delegate: ProductDelegate(items: items),
    //         query: query);
    //   }
    // }

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
              child: Text("Discover",
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
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
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

// class ProductDelegate extends SearchDelegate<String> {
//   final List<String> items;
//   ProductDelegate({required this.items});

//   List<String> recentSearches = [
//     'Item 1',
//     'Item 2',
//     'Item 3',
//     'Item 4',
//     'Item 5',
//   ];
//   @override
//   String get searchFieldLabel => 'Search products';

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> results = items
//         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text(results[index]),
//             onTap: () {
//               query = results[index];
//               showResults(context);
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => SearchScreen(
//                         search: "",
//                         header: query,
//                       )));
//             },
//           );
//         });
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> suggestions = query.isEmpty
//         ? items
//         : items
//             .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//     return ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text(suggestions[index]),
//             onTap: () {
//               query = suggestions[index];
//               showResults(context);
//             },
//           );
//         });
//   }
// }

class _UnfocusMode extends StatelessWidget {
  const _UnfocusMode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
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
  const _Catagories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderTitles(
          title: "Categories",
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
              CatagoryBox(
                  name: "Electric",
                  url:
                      "https://th.bing.com/th/id/R.fc2f064b07408772f3b10c6ac237ea77?rik=Ec6ViyajY83x4A&pid=ImgRaw&r=0"),
            ],
          ),
        )
      ],
    );
  }
}

class _MostPopular extends StatelessWidget {
  const _MostPopular();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderTitles(title: "Most popular"),
        SizedBox(
          height: 250,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            InkWell(
                onTap: () {
                  // Navigator.of(context).push(DetailsScreen.route());
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const DetailsScreen()));
                },
                child: MostPopular()),
            MostPopular(),
            MostPopular(),
            MostPopular(),
          ]),
        ),
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
          child: ListView(scrollDirection: Axis.horizontal, children: const [
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
