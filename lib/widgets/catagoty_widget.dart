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
          'Explore our extensive collection of electronics, designed to enhance your daily life. Discover high-quality devices including smartphones, laptops, tablets, and smart home technology. Shop for the latest gadgets, audio and video equipment, gaming consoles, and accessories to stay connected and entertained.',
      'image': 'assets/images/electronic.png',
    },
    {
      'name': "Vehicles",
      'description':
          "Browse our wide range of vehicles and vehicle parts to meet your transportation needs. Explore a variety of cars, motorcycles, trucks, and SUVs, along with essential parts and accessories. Find quality vehicles and components for a reliable and enjoyable driving experience.",
      'image': "assets/images/car.png"
    },
    {
      'name': "Food",
      'description':
          "Indulge in a diverse selection of food products to satisfy your cravings. Discover dry goods, canned and jarred foods, snacks, beverages, dairy and dairy alternatives, frozen foods, fresh produce, and bakery items. Explore a world of delicious options to suit your taste buds.",
      "image": "assets/images/food.png",
    },
    {
      'name': "Stationery",
      'description':
          "Discover essential stationary items for writing, organization, and creativity. From paper and pens to notebooks and desk accessories, our collection offers quality products to meet your needs. Shop now for a productive workspace.",
      "image": "assets/images/stationery.png",
    },
    {
      'name': 'Home Appliances',
      'description':
          "Enhance your home with our range of high-quality appliances. Explore a wide selection of kitchen appliances, including refrigerators, ovens, and dishwashers. Discover efficient laundry appliances like washing machines and dryers. Find air conditioners, vacuums, and smart home devices to make your living space comfortable and convenient.",
      'image': "assets/images/home-appliance.png"
    },
    {
      "name": "Furniture",
      "description":
          "Transform your living space with our stylish furniture collection. Explore a wide range of pieces for every room, including living room sofas, dining tables, bedroom sets, and office desks. Discover high-quality materials, innovative designs, and functional features to create your dream home.",
      "image": "assets/images/furnitures.png"
    },
    {
      "name": "Ceramic",
      "description":
          "Discover the beauty and functionality of ceramic products. Explore a wide range of ceramic items, including dinnerware sets, mugs, vases, and decorative pieces. Experience the elegance and versatility of ceramic in your home, adding a touch of style and sophistication to your living space.",
      "image": "assets/images/ceramic.png"
    },
    {
      'name': "Home & Decor",
      'description':
          "Transform your home with our exquisite home and decor collection. Explore a diverse range of furniture, lighting fixtures, rugs, curtains, and wall art to suit your style and preferences. Create a warm and inviting ambiance with our carefully curated selection of home decor items",
      'image': "assets/images/flower.png"
    },
    {
      'name': "Sports & Fitness",
      'description':
          "Get active and stay fit with our comprehensive sports and fitness collection. Explore a wide range of equipment, including cardio machines, weightlifting gear, yoga accessories, and sports apparel. Discover everything you need to support your active lifestyle and achieve your fitness goals.",
      'image': "assets/images/fitness.png"
    },
    {
      'name': "Tools & Equipment",
      'description':
          "Find the right tools and equipment for any project with our extensive collection. Explore a wide range of power tools, hand tools, gardening equipment, and hardware supplies. From construction to DIY projects, we have the tools you need to get the job done efficiently and effectively.",
      'image': "assets/images/toolbox.png"
    },
    {
      'name': "Clothing & Accessories",
      'description':
          "Elevate your style with our fashionable clothing and accessories. Discover a wide range of trendy apparel for men, women, and children, including tops, bottoms, dresses, and outerwear. Complete your look with accessories like bags, shoes, jewelry, and hats. Find the perfect pieces to express your unique fashion sense.",
      'image': "assets/images/handbag.png"
    },
    {
      "name": "Toys & Games",
      "description": "",
      "image": "assets/images/puzzle.png"
    },
    {
      'name': "Jewellery",
      'description':
          "Adorn yourself with our stunning jewelry collection. Explore a wide variety of exquisite necklaces, earrings, bracelets, rings, and watches. Discover fine jewelry crafted with precious metals and gemstones, as well as trendy fashion jewelry to elevate your style. Find the perfect piece to add a touch of elegance and sparkle to any out",
      'image': "assets/images/jewelry.png"
    },
    {
      'name': "Tableware",
      'description':
          "Elevate your dining experience with our elegant tableware collection. Explore a wide range of plates, bowls, glasses, cutlery, and serving dishes. From everyday essentials to special occasion sets, our tableware combines style and functionality to enhance your meals and gatherings. Set a beautiful table and create lasting memories with our exquisite selection.",
      'image': "assets/images/tableware.png"
    },
    {
      'name': "Party & Event",
      'description':
          "Make your next party or event unforgettable with our selection of party supplies and decorations. From birthdays to weddings, find everything you need to create a festive atmosphere. Explore themed decorations, balloons, tableware, and party favors to bring your celebration to life. Let the party planning begin!",
      'image': "assets/images/people.png"
    },
    {
      'name': "Camping & Outdoors",
      'description':
          "Embrace the great outdoors with our camping and outdoor gear. Explore a wide range of camping equipment, including tents, sleeping bags, backpacks, and camping stoves. Discover outdoor essentials such as hiking gear, portable chairs, and coolers. Gear up for your next adventure and enjoy nature to the fulle",
      'image': "assets/images/tent.png"
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
