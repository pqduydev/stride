import 'package:flutter/material.dart';

class ItemSocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;

  const ItemSocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF1C2520),
    this.borderColor,
    this.fontWeight = .w500,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SizedBox(width: 24, height: 24, child: Center(child: icon)),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
