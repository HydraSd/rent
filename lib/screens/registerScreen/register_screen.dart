import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:rent/screens/registerScreen/register_preview.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool nameError = false;
  bool desError = false;

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  List<File> images = [];
  final controller =
      MultiImagePickerController(maxImages: 1, images: <ImageFile>[]);

  String? phoneNumber;

  void imageSet() {
    setState(() {
      images = controller.images.map((e) => File(e.path!)).toList();
    });
  }

  void register() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (!nameError && !desError) {
      imageSet();

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfilePreview(
                images: images,
                name: name.text,
                phoneNumber: phoneNumber!,
                description: description.text,
              )));
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: Theme.of(context).textTheme.headline6,
          title: const Text("Register your business")),
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
                            register();
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
                                "Sell",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
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
