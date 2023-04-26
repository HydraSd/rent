import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageScroller extends StatelessWidget {
  final List<dynamic> imagUrls;

  const ImageScroller({super.key, required this.imagUrls});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 400,
          autoPlay: true,
          // autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
        ),
        items: imagUrls.map((image) {
          return Container(
            width: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          );
        }).toList(),
      ),
    );
  }
}
