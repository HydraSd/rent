import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({
    Key? key,
    required this.controller,
    required this.imageError,
  }) : super(key: key);

  final MultiImagePickerController controller;
  final bool imageError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiImagePickerView(
          controller: controller,
          draggable: true,
          padding: const EdgeInsets.all(30),
        ),
        Visibility(
          visible: imageError,
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "Please select at least one image",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
