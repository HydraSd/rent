import 'package:flutter/material.dart';

class CatagoryBox extends StatelessWidget {
  final String url;
  final String name;
  const CatagoryBox({Key? key, required this.url, required this.name})
      : super(key: key);

  // late PaletteGenerator _paletteGenerator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // height: 100,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 70,
                  child: Image(
                    image: AssetImage(url),
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(name),
              )
            ],
          ),
        ),
      ),
    );
  }
}
