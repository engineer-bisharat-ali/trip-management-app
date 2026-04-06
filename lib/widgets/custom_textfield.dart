import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  // optional add
  final TextInputType? keyboardType; // optional add

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,

    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final textFontSize = isMobile ? 15.0 : 16.0;
    final labelFontSize = isMobile ? 13.0 : 14.0;
    final hintFontSize = isMobile ? 14.0 : 15.0;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: textFontSize,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,

        // Label styles
        labelStyle: TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
        hintStyle: TextStyle(
          fontSize: hintFontSize,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconTheme(
            data: const IconThemeData(color: Colors.blue, size: 20),
            child: prefixIcon,
          ),
        ),

        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
