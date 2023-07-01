import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:rent/screens/screens.dart';
import 'package:rent/widgets/description_box.dart';
import 'package:rent/widgets/product_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateScreen extends StatefulWidget {
  final String productName;
  final double price;
  final String description;
  final String documentId;
  const UpdateScreen(
      {super.key,
      required this.productName,
      required this.price,
      required this.description,
      required this.documentId});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String? _selectedItem;
  final List<String> _catagories = [
    "Electronics",
    "Home Appliances",
    "Furniture",
    "Party and Event",
    "Tools and Equipment",
    "Clothing and Accessories",
    "Toys and Games",
    "Toys and Games",
    "Vehicles"
  ];
  final FocusNode focusNode = FocusNode();
  final FocusNode desFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final weekController = TextEditingController();
  final desController = TextEditingController();
  bool priceError = false;
  bool priceInvalid = false;
  bool nameError = false;
  bool catagoryError = false;
  bool desError = false;
  bool imgError = false;
  bool weekends = false;
  bool weekendError = false;
  bool locationError = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.productName;
    priceController.text = widget.price as String;
    desController.text = widget.description;
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

  Future<void> updateDocument(String productName, String price,
      String description, String catagory) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('test');
    final DocumentReference documentReference =
        collectionReference.doc(widget.documentId);
    try {
      await documentReference.update({
        'productName': productName,
        'description': description,
        'category': catagory,
        'price': price
      });
    } catch (e) {
      null;
    }
  }

  void update() {
    if (nameController.text.isNotEmpty &&
        priceCheck() &&
        _selectedItem != null &&
        desController.text.isNotEmpty &&
        weekEndPrice()) {
      setState(() {
        imgError = false;
        nameError = false;
        priceError = false;
        catagoryError = false;
        desError = false;
        weekendError = false;
        locationError = false;
      });
      confirmation(context);
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

      // Form is invalid, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  confirmation(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text("Update confirmation"),
          content: const Text(
              "By clicking confirmation your going to update your product"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  updateDocument(nameController.text, priceController.text,
                      desController.text, _selectedItem!);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
                child: const Text("Confirm"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          {focusNode.unfocus(), desFocus.unfocus(), priceFocus.unfocus()},
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("Update your product"),
          titleTextStyle: Theme.of(context).textTheme.headline6,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProductName(
                  nameController: nameController,
                  focusNode: focusNode,
                  nameError: nameError),
            ),
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
                                hintText:
                                    "Enter the price per a day(Week end days)"),
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
            )),
            SliverToBoxAdapter(
                child: DescriptionBox(
                    desController: desController,
                    focusNode: desFocus,
                    desError: desError)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Bounceable(
                  onTap: () {
                    update();
                  },
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue),
                      child: const Center(
                          child: Text(
                        "Update",
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
}
