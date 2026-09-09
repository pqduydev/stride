import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Nhật ký",
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontSize: 50, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
