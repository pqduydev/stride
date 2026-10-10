import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemTextField extends StatelessWidget {
  final Color textColor;
  final double textFontSize;
  final FontWeight textFontWeight;
  final String? hintText;
  final int? hintTextColor;
  final double? hintTextFontSize;
  final FontWeight? hintTextFontWeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final String? borderStyle;
  final double? borderRadius;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

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
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller?.text,
      validator: validator,
      builder: (field) {
        final hasError = field.hasError;

        return TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: (value) => field.didChange(value),
              style: TextStyle(
                color: textColor,
                fontSize: textFontSize,
                fontWeight: textFontWeight,
              ),
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(hintTextColor ?? 0xFF8E8E93),
                  fontSize: hintTextFontSize,
                  fontWeight: hintTextFontWeight ?? .w500,
                ),
                filled: true,
                fillColor: backgroundColor ?? Colors.white,
                helperText: ' ',
                helperStyle: const TextStyle(fontSize: 12, height: 1.2),
                errorText: hasError ? field.errorText : null,
                errorStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  height: 1.2,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor ?? const Color(0xFF8E8E93),
                    width: borderWidth ?? 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: borderColor ?? const Color(0xFF8E8E93),
                    width: borderWidth ?? 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
            .animate(key: ValueKey(field.errorText))
            .shakeX(hz: 4, amount: hasError ? 4 : 0, duration: 400.ms);
      },
    );
  }
}
