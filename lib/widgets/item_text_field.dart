import 'package:flutter/material.dart';

class ItemTextField extends StatelessWidget {
  final int textColor;
  final double textFontSize;
  final FontWeight textFontWeight;
  final String? hintText;
  final int? hintTextColor;
  final double? hintTextFontSize;
  final FontWeight? hintTextFontWeight;
  final String? backgroundColor;
  final String? borderColor;
  final double? borderWidth;
  final String? borderStyle;
  final double? borderRadius;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const ItemTextField({
    super.key,
    required this.textColor,
    required this.textFontSize,
    required this.textFontWeight,
    this.hintText,
    this.hintTextColor,
    this.hintTextFontSize,
    this.hintTextFontWeight,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderStyle,
    this.borderRadius,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Color(textColor),
        fontSize: textFontSize,
        fontWeight: textFontWeight,
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(hintTextColor ?? 0xFF8E8E93),
          fontSize: hintTextFontSize,
          fontWeight: hintTextFontWeight ?? FontWeight.w500,
        ),
        filled: true,
        fillColor: Color(
          backgroundColor != null ? int.parse(backgroundColor!) : 0xFFFFFFFF,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(
              borderColor != null ? int.parse(borderColor!) : 0xFF8E8E93,
            ),
            width: borderWidth ?? 1,
            style: borderStyle == 'dashed'
                ? BorderStyle.solid
                : BorderStyle.solid,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(
              borderColor != null ? int.parse(borderColor!) : 0xFF8E8E93,
            ),
            width: borderWidth ?? 1,
            style: borderStyle == 'dashed'
                ? BorderStyle.solid
                : BorderStyle.solid,
          ),

          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
