import 'package:flutter/material.dart';
import 'package:rent/screens/catagories_screen_main.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, String>> categoryData;
  const CategoriesScreen({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Categories"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: ListView.builder(
          itemCount: categoryData.length,
          itemBuilder: (BuildContext context, int index) {
            final category = categoryData[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Catagories(
                        catagory: category['name'].toString(),
                        des: category['description'].toString()))),
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("${category['image']}"))),
                  ),
                  title: Text("${category['name']}"),
                ),
              ),
            );
          }),
    );
  }
}
