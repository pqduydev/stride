import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stride/model/reminder_settings.dart';

class ReminderSettingsRepository {
  static const _key = 'reminder_settings';

  Future<ReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) {
      final now = DateTime.now();
      return ReminderSettings(
        hour: now.hour,
        minute: now.minute,
        minutesBefore: 5,
      );
    }
    return ReminderSettings.fromJson(jsonDecode(jsonString));
  }

  Future<void> save(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}
