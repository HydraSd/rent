import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:rent/screens/home_screen.dart';
import 'package:rent/widgets/requestBtn.dart';

class UpdateBusinessProfile extends StatefulWidget {
  final String businessName;
  final String imgUrl;
  final String phoneNumber;
  final String description;
  final String documentId;

  const UpdateBusinessProfile(
      {super.key,
      required this.businessName,
      required this.imgUrl,
      required this.phoneNumber,
      required this.description,
      required this.documentId});

  @override
  State<UpdateBusinessProfile> createState() => _UpdateBusinessProfileState();
}

class _UpdateBusinessProfileState extends State<UpdateBusinessProfile> {
  final _formKey = GlobalKey<FormState>();
  bool nameError = false;
  bool desError = false;

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  List<File> images = [];
  final controller =
      MultiImagePickerController(maxImages: 1, images: <ImageFile>[]);

  String? phoneNumber;

  bool isLoading = false;

  void imageSet() {
    setState(() {
      images = controller.images.map((e) => File(e.path!)).toList();
    });
  }

  Future<void> deleteFile(String url) async {
    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDocument(
      String businessName, String description, String? phoneNumber) async {
    setState(() {
      isLoading = true;
    });
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('userProfile');
    final DocumentReference documentReference =
        collectionReference.doc(widget.documentId);
    try {
      if (images.isEmpty) {
        await documentReference.update({
          'businessName': businessName,
          'description': description,
          'phoneNumber': phoneNumber,
        });
      }
      if (images.isNotEmpty) {
        File image = images[0];
        String imageName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(imageName);
        await ref.putFile(image);
        String imgUrl = await ref.getDownloadURL();
        deleteFile(widget.imgUrl);
        await documentReference.update({
          "logoUrl": imgUrl,
          'businessName': businessName,
          'description': description,
          'phoneNumber': phoneNumber,
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      null;
    }
  }

  void register(String businessName, String description, String? phoneNumber) {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (!nameError && !desError) {
      imageSet();
      updateDocument(businessName, description, phoneNumber!);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
    _formKey.currentState!.save();
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.businessName;
    description.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("Update your store"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ),
      body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22.0),
                        child: Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: MultiImagePickerView(controller: controller),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                              hintText: "Business name or your name",
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                nameError = true;
                              });
                            } else {
                              setState(() {
                                nameError = false;
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                      Visibility(
                          visible: nameError,
                          child: const Text(
                            "Please enter your name or business name",
                            style: TextStyle(color: Colors.redAccent),
                          )),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).cardColor),
                        child: InternationalPhoneNumberInput(
                          initialValue:
                              PhoneNumber(isoCode: 'LK', dialCode: '+94'),
                          onInputChanged: (PhoneNumber number) {
                            setState(() {
                              phoneNumber = '${number.phoneNumber}';
                            });
                          },
                          inputBorder: InputBorder.none,
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          autoValidateMode: AutovalidateMode.disabled,
                          formatInput: true,
                          ignoreBlank: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: description,
                            maxLines: 8,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    "Enter a small description about your business"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  desError = true;
                                });
                              } else {
                                setState(() {
                                  desError = false;
                                });
                              }
                              return null;
                            },
                          )),
                      Visibility(
                          visible: desError,
                          child: const Text(
                            "Please enter a small description about your product",
                            style: TextStyle(color: Colors.redAccent),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Bounceable(
                          onTap: () {
                            register(name.text, description.text, phoneNumber);
                          },
                          child: (isLoading)
                              ? const Center(child: CircularProgressIndicator())
                              : const RequestBtn(btnText: "Update"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
