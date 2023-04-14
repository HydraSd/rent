import 'package:flutter/material.dart';

class MostPopular extends StatelessWidget {
  const MostPopular({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                      "https://th.bing.com/th/id/R.0f56d0df1baad933c6fa520f97fe5d3a?rik=PAx7TflC0QQO0A&pid=ImgRaw&r=0"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "HeadSet",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Rs.200",
                      style: TextStyle(fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
