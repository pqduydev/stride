import 'package:flutter/material.dart';

class ItemTextField extends StatelessWidget {
  final String hintText;

  const new({super.key, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: const Color(0xFF1C2520),
        fontSize: 15,
        fontWeight: .w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF768079),
          fontSize: 15,
          fontWeight: .w500,
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFE8ECE8),
            width: 1,
            style: BorderStyle.solid,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFE8ECE8),
            width: 1,
            style: BorderStyle.solid,
          ),

          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
