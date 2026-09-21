import 'package:flutter/material.dart';

class ItemInfomation extends StatelessWidget {
  const ItemInfomation({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 98,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: Color(0xFFEEF4E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF526C30),
              fontSize: 14,
              fontWeight: .w600,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              color: Color(0xFF768079),
              fontSize: 13,
              fontWeight: .w400,
            ),
          ),
        ],
      ),
    );
  }
}
