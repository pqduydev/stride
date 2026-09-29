import 'package:flutter/material.dart';

class ReminderSavedScreen extends StatelessWidget {
  const ReminderSavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Nhắc hẹn thành công",
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontSize: 50, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
