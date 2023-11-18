import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishColor = Color(0xff4e5ae8);
const Color yellowishColor = Color(0xffFFBC76);
const Color pinkColor = Color(0xffFF4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xff121212);
const Color darkHeaderColor = Color(0xFF424242);
const Color greenColor = Colors.green;

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: white,
      primary: primaryColor,
    ),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: white,
    //   elevation: 0,
    //   iconTheme: IconThemeData(
    //     color: Colors.black,
    //   ),
    // ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: darkGreyColor,
      primary: primaryColor,
    ),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: darkGreyColor,
    //   elevation: 0,
    //   iconTheme: IconThemeData(
    //     color: Colors.white,
    //   ),
    // ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
  ));
}
