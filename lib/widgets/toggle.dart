import 'package:flutter/material.dart';

class AboutPrice extends StatefulWidget {
  AboutPrice({super.key, required this.about, required this.price});

  bool about;
  bool price;

  @override
  State<AboutPrice> createState() => _AboutPriceState();
}

class _AboutPriceState extends State<AboutPrice> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  setState(() {
                    widget.about = true;
                    widget.price = false;
                  });
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.about
                        ? Colors.blue
                        : Theme.of(context).cardColor),
                child: const Text("About"),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.price = true;
                  widget.about = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.price
                        ? Colors.blue
                        : Theme.of(context).cardColor),
                child: const Text("Price"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
