import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReminderSavedScreen extends StatelessWidget {
  const ReminderSavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'reminder_saved.title'.tr(),
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontSize: 50, fontWeight: .w700),
        ),
      ),
    );
  }
}
