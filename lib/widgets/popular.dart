import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MostPopular extends StatelessWidget {
  MostPopular({
    Key? key,
  }) : super(key: key);

  bool rented = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Image.network(
                      "https://th.bing.com/th/id/OIP.HxV79tFMPfBAIo0BBF-sOgHaEy?pid=ImgDet&rs=1",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "HeadSet",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 20),
                              (rented)
                                  ? const Text(
                                      "available",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green),
                                    )
                                  : const Text(
                                      "rented",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.redAccent),
                                    )
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                              Icon(Icons.star, color: Colors.yellow, size: 18),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
