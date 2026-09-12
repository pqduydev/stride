import 'package:flutter/material.dart';

class AppointmentReminderScreen extends StatelessWidget {
  const AppointmentReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Nhắc hẹn",
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontSize: 50, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
