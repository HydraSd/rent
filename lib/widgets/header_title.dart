import 'package:flutter/material.dart';
import 'package:rent/productScreen/popular_screen.dart';

class HeaderTitles extends StatelessWidget {
  final String title;
  const HeaderTitles({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        GestureDetector(
            // onTap: () {
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const PopularRecommended(
            //             appBarTitle: "Most popular products",
            //           )));
            // },
            child: const Icon(Icons.arrow_forward))
      ],
    );
  }
}
