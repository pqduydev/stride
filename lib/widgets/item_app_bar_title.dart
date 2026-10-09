import 'package:flutter/material.dart';

class ItemAppBarTitle extends StatelessWidget {
  final String data;
  final double? padding;

  const ItemAppBarTitle({super.key, required this.data, this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: padding!),
      child: Text(
        data,
        style: TextStyle(
          color: Color(0xFF1C2520),
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    ;
  }
}
