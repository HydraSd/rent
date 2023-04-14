import 'dart:io';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:rent/screens/map_screen.dart';
import 'package:rent/screens/preview_screen.dart';
import 'package:rent/widgets/widget.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  final FocusNode focusNode = FocusNode();
  final FocusNode desFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();
  final weekController = TextEditingController();
  final controller =
      MultiImagePickerController(maxImages: 3, images: <ImageFile>[]);
  String? _selectedItem;
  final List<String> _catagories = ["Electric", "Clothes", "Cata1", "Cata3"];
  List<File> images = [];
  bool priceError = false;
  bool priceInvalid = false;
  bool nameError = false;
  bool catagoryError = false;
  bool desError = false;
  bool imgError = false;
  bool weekends = false;
  bool weekendError = false;
  bool locationError = false;

  String? location1;
  double? lat;
  double? long;

  Future<void> _navigateToMapScreen() async {
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (result != null) {
      final double latitude = result['latitude'];
      final double longitude = result['longitude'];
      final String location = result['location'];

      setState(() {
        location1 = location;
        lat = latitude;
        long = longitude;
      });
      // Do something with the latitude, longitude, and location
    }
  }

  bool priceCheck() {
    if (priceController.text.isNotEmpty) {
      double? price;
      try {
        price = double.parse(priceController.text);
      } catch (e) {
        setState(() {
          priceError = true;
        });
        return false;
      }
      if (price is double) {
        return true;
      }
      setState(() {
        priceError = true;
      });
      return false;
    } else {
      setState(() {
        weekendError = true;
      });
      return false;
    }
  }

  bool weekEndPrice() {
    if (weekends) {
      if (weekController.text.isNotEmpty) {
        double? weekend;
        try {
          weekend = double.parse(weekController.text);
        } catch (e) {
          setState(() {
            weekendError = true;
          });
          return false;
        }
        if (weekend is double) {
          return true;
        }
        setState(() {
          weekendError = true;
        });
        return false;
      } else {
        setState(() {
          weekendError = true;
        });
        return false;
      }
    } else {
      setState(() {
        weekController.text = '';
      });
      return true;
    }
  }

  void imageSet() {
    setState(() {
      images = controller.images.map((e) => File(e.path!)).toList();
    });
  }

  void _rentButtonPressed() {
    imageSet();
    if (nameController.text.isNotEmpty &&
        priceCheck() &&
        _selectedItem != null &&
        desController.text.isNotEmpty &&
        weekEndPrice() &&
        images.isNotEmpty &&
        location1 != null) {
      setState(() {
        imgError = false;
        nameError = false;
        priceError = false;
        catagoryError = false;
        desError = false;
        weekendError = false;
        locationError = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PreviewScreen(
                catagory: _selectedItem!,
                images: images,
                productName: nameController.text,
                description: desController.text,
                price: priceController.text,
                weekendPrice: weekController.text,
                lat: lat!,
                long: long!,
                location: location1!,
              )));
    } else {
      if (nameController.text.isEmpty) {
        setState(() {
          nameError = true;
        });
      } else if (nameController.text.isNotEmpty) {
        setState(() {
          nameError = false;
        });
      }
      priceCheck();
      if (_selectedItem == null) {
        setState(() {
          catagoryError = true;
        });
      } else if (_selectedItem != null) {
        setState(() {
          catagoryError = false;
        });
      }
      if (desController.text.isEmpty) {
        setState(() {
          desError = true;
        });
      } else if (desController.text.isNotEmpty) {
        setState(() {
          desError = false;
        });
      }
      weekEndPrice();
      if (images.isEmpty) {
        print(images);
        setState(() {
          imgError = true;
        });
      } else {
        setState(() {
          imgError = false;
        });
      }
      if (location1 == null) {
        setState(() {
          locationError = true;
        });
      } else if (location1 != null) {
        setState(() {
          locationError = false;
        });
      }

      // Form is invalid, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () =>
          {focusNode.unfocus(), desFocus.unfocus(), priceFocus.unfocus()},
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Rent your product",
            style: TextStyle(
                color: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: ProductName(
                    nameController: nameController,
                    focusNode: focusNode,
                    nameError: nameError)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonFormField<String>(
                        value: _selectedItem,
                        onChanged: (value) =>
                            setState(() => _selectedItem = value!),
                        items: _catagories.map((catagory) {
                          return DropdownMenuItem(
                              value: catagory, child: Text(catagory));
                        }).toList(),
                        decoration: const InputDecoration(
                            hintText: "Select the Catagory",
                            border: InputBorder.none),
                      ),
                    ),
                    Visibility(
                      visible: catagoryError,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8, top: 5),
                        child: Text(
                          "Please select a catagory",
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8),
            //     child: Container(
            //       padding: const EdgeInsets.only(left: 10),
            //       height: 50,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(5),
            //           color: Theme.of(context).cardColor),
            //       child: const TextField(
            //         keyboardType: TextInputType.phone,
            //         decoration: InputDecoration(
            //             border: InputBorder.none,
            //             hintText: "Enter your contact number"),
            //       ),
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(child: prices(context)),
            SliverToBoxAdapter(
              child:
                  ImageSelector(controller: controller, imageError: imgError),
            ),
            SliverToBoxAdapter(
                child: DescriptionBox(
                    desController: desController,
                    focusNode: desFocus,
                    desError: desError)),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      _navigateToMapScreen();
                    },
                    child: Row(children: [
                      const Expanded(child: Icon(Icons.location_on)),
                      Expanded(
                        child: (location1 != null)
                            ? Text(location1!)
                            : const Text("Select your location"),
                      ),
                    ]),
                  ),
                  Visibility(
                      visible: (locationError),
                      child: const Text(
                        "Please select a location",
                        style: TextStyle(color: Colors.redAccent),
                      ))
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Bounceable(
                  onTap: () {
                    _rentButtonPressed();
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        "Rent",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding prices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardColor),
            child: TextFormField(
              focusNode: priceFocus,
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter the price per a day"),
            ),
          ),
          Visibility(
            visible: priceError,
            child: const Padding(
              padding: EdgeInsets.only(left: 8, top: 5),
              child: Text(
                "Please enter a valid amount",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          Row(
            children: [
              CustomCheckBox(
                  shouldShowBorder: true,
                  borderColor: Colors.blue,
                  checkedFillColor: Colors.blue,
                  borderRadius: 5,
                  borderWidth: 1,
                  checkBoxSize: 18,
                  value: weekends,
                  onChanged: (val) {
                    setState(() {
                      weekends = val;
                    });
                  }),
              const Text("Do you have special price for week ends")
            ],
          ),
          Visibility(
            visible: weekends,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).cardColor),
                  child: TextFormField(
                    controller: weekController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the price per a day(Week end days)"),
                  ),
                ),
                Visibility(
                  visible: weekendError,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8, top: 5),
                    child: Text(
                      "Please enter a valid amount",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
