import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MostPopular extends StatelessWidget {
  String description;
  String productName;
  String imgURL;
  MostPopular(
      {Key? key,
      this.productName = '',
      this.description = '',
      this.imgURL =
          'https://th.bing.com/th/id/OIP.HxV79tFMPfBAIo0BBF-sOgHaEy?pid=ImgDet&rs=1'})
      : super(key: key);

  bool rented = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
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
                  SizedBox(
                    height: 150,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Image.network(
                        imgURL,
                        fit: BoxFit.cover,
                      ),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    // Text(
                                    //   distance,
                                    //   style:
                                    //       const TextStyle(color: Colors.blue),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          Expanded(
                              child: Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                          // Row(
                          //   children: const [
                          //     Icon(Icons.star, color: Colors.yellow, size: 18),
                          //     Icon(Icons.star, color: Colors.yellow, size: 18),
                          //     Icon(Icons.star, color: Colors.yellow, size: 18),
                          //     Icon(Icons.star, color: Colors.yellow, size: 18),
                          //     Icon(Icons.star, color: Colors.yellow, size: 18),
                          //   ],
                          // )
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
