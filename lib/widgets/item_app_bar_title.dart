import 'package:flutter/material.dart';

class ItemAppBarTitle extends StatelessWidget {
  final String data;

  const new({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: Color(0xFF1C2520),
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
