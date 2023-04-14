import 'package:flutter/material.dart';
import 'package:rent/screens/screens.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.name});
  final String name;

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
              "Hello, $name",
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
        GestureDetector(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RentScreen())),
          child: const ListTile(
            leading: Icon(Icons.sell_outlined),
            title: Text(
              "Rent a product",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => YourProducts())),
          child: const ListTile(
            leading: Icon(Icons.attach_money_sharp),
            title: Text(
              "Your products",
              style: TextStyle(fontSize: 16),
            ),
          ),
        )
      ]),
    );
  }
}
