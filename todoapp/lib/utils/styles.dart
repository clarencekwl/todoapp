import 'package:flutter/material.dart';

class Styles {
  static Color primaryBaseColor = const Color.fromRGBO(58, 66, 86, 1.0);
  static Color cardColor = const Color.fromRGBO(64, 75, 96, .9);
  static Color secondaryColor = Colors.white;
  static TextStyle titleText = const TextStyle(
      fontFamily: "Inter",
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18.5);
  static TextStyle detailsText =
      const TextStyle(color: Colors.white, fontSize: 15.0);
  static TextStyle subTitleText =
      const TextStyle(color: Colors.white, fontSize: 12);
  static TextStyle headerText = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25);
  static TextStyle hintText =
      TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.5));
  static TextStyle userInputText = const TextStyle(color: Colors.white);

  static Color buttonColor = const Color.fromARGB(225, 243, 249, 252);
  static Color buttonTextColor = Colors.black;
  static Color blueColor = const Color.fromARGB(122, 34, 185, 250);
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.only(left: 20, right: 20),
      backgroundColor: Styles.buttonColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

  static InputDecoration inputTextFieldStyle(String label,
      {bool isDatePicker = false}) {
    return InputDecoration(
      prefixIcon: isDatePicker ? const Icon(Icons.date_range_rounded) : null,
      labelText: label,
      errorStyle: const TextStyle(height: 0, fontSize: 12),
      labelStyle: const TextStyle(
          fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 0.5,
            color: Colors.white,
          )),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red.shade900),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red.shade900),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double kScreenHeight(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) * percentage;
  }

  static double kScreenWidth(BuildContext context,
      {double percentage = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) * percentage;
  }
}
