import 'package:flutter/material.dart';
import 'package:rent/productScreen/categories_screen.dart';
import 'package:rent/screens/catagories_screen_main.dart';
import 'package:rent/widgets/catagory_card.dart';

// ignore: unused_element
class CatagoriesWid extends StatelessWidget {
  CatagoriesWid({
    Key? key,
  }) : super(key: key);

  final List<Map<String, String>> categoryData = [
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen(
                            categoryData: categoryData,
                          )));
                },
                child: const Icon(Icons.arrow_forward))
          ],
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryData.length,
              itemBuilder: (context, index) {
                final category = categoryData[index];
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
