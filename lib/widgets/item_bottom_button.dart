import 'package:flutter/material.dart';

class ItemBottomButton extends StatelessWidget {
  final String data;

  const new({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: InkWell(
        onTap: () {},
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFD2F36B),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            data,
            style: TextStyle(
              color: Color(0xFF1C2520),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
