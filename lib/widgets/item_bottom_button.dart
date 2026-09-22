import 'package:flutter/material.dart';

class ItemBottomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final int? color;
  final int? textColor;
  final double? borderWidth;
  final int? borderColor;

  const ItemBottomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.color = 0xFFD2F36B,
    this.textColor = 0xFF1C2520,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: .center,
        decoration: BoxDecoration(
          color: Color(color!),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: borderColor != null
                ? Color(borderColor!)
                : Colors.transparent,
            width: borderWidth ?? 0,
            style: BorderStyle.solid,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  color: Color(textColor!),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
