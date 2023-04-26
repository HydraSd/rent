import 'package:flutter/material.dart';
import 'package:rent/screens/screens.dart';

class Content extends StatelessWidget {
  const Content({
    Key? key,
    required this.lat,
    required this.long,
    required this.location,
    required this.description,
  }) : super(key: key);

  final double lat;
  final double long;
  final String location;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DirectionScreen(
                          lat: lat,
                          long: long,
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Expanded(child: Icon(Icons.location_on)),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(fontSize: 15),
                    ),
                  )
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 10)
      ]),
    );
  }
}
