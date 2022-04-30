import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final EdgeInsets? padding;
  final bool? obscureText;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.hint,
    required this.label,
    this.padding,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'Segoe',
            color: Colors.black,
          ),
          labelStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'Segoe',
            color: Colors.black,
          ),
        ),
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Segoe',
          color: Colors.black,
        ),
        keyboardType: TextInputType.text,
        maxLines: 1,
        autofocus: false,
        obscureText: obscureText ?? false,
      ),
    );
  }
}
