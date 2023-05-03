import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class AccountBtn extends StatelessWidget {
  const AccountBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: const Center(
                child: Text(
              "Save",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
