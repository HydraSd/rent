import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent/func/google_sign_in.dart';
import '../screens/screens.dart';
import 'package:rent/widgets/widget.dart';
import 'package:rent/MainCatagories/most_popular_wid.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

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
            userId: user.uid,
            name: "${user.displayName}",
          ),
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("RedMix",
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
                            if (_searchController.text != null &&
                                _searchController.text.isNotEmpty) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                        header: _searchController.text,
                                        search: _searchController.text,
                                      )));
                            }
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
                                search: _searchController.text,
                              )));
                    },
                  ),
                ),
              ),
            ),
          ),
          body: const _UnfocusMode()),
    );
  }
}

class _UnfocusMode extends StatelessWidget {
  const _UnfocusMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ImageSlideshow(
            height: 200,
            width: double.infinity,
            indicatorColor: Colors.blue,
            autoPlayInterval: 3000,
            isLoop: true,
            children: [
              Image.asset(
                "assets/images/banners/banner1.png",
                fit: BoxFit.fill,
              ),
              Image.asset(
                "assets/images/banners/banner2.png",
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: CatagoriesWid()),
        const SliverToBoxAdapter(child: MostPopularWid()),
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
