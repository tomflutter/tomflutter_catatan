import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tomflutter_catatan/theme/theme.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          height: 52,
          margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: TextFormField(
                  readOnly: widget != null ? true : false,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[200] : Colors.grey[700],
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              widget ??
                  Container(
                    child: widget,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
