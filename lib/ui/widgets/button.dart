import 'package:flutter/material.dart';
import 'package:tomflutter_catatan/theme/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 100,
        // height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryColor, // Move color property here
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(label,
            style: const TextStyle(
              color: white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
