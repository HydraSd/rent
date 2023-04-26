import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  TextEditingController numberController = TextEditingController();

  bool template = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/logo2.png"),
                    fit: BoxFit.fill)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, top: 14),
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardColor),
            child: InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'LK', dialCode: '+94'),
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              inputBorder: InputBorder.none,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              formatInput: true,
              ignoreBlank: false,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, top: 14),
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardColor),
            child: TextFormField(
              controller: numberController,
              decoration: const InputDecoration(
                  hintText: "Enter your national ID number",
                  border: InputBorder.none),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              CustomCheckBox(
                onChanged: (val) {
                  setState(() {
                    template = val;
                  });
                },
                shouldShowBorder: true,
                borderColor: Colors.blue,
                checkedFillColor: Colors.blue,
                borderRadius: 5,
                borderWidth: 1,
                checkBoxSize: 15,
                value: template,
              ),
              const Text("Save as a template")
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 150,
          child: Bounceable(
            onTap: () {
              // NotificationApi.showNotification(
              //     title: 'sandhil', body: 'test product', payload: 'san.com');
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
                  child: Icon(
                    Icons.arrow_forward,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}