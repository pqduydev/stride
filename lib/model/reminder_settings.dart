import 'package:equatable/equatable.dart';

class ReminderSettings extends Equatable {
  final bool enabled;
  final int hour; // giờ tập
  final int minute;
  final Set<int> weekdays; // DateTime.monday (1) ... DateTime.sunday (7)
  final int minutesBefore; // 5, 15, 30, 60

  const ReminderSettings({
    this.enabled = false,
    this.hour = 18,
    this.minute = 0,
    this.weekdays = const {},
    this.minutesBefore = 5,
  });

  ReminderSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    Set<int>? weekdays,
    int? minutesBefore,
  }) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
      minutesBefore: minutesBefore ?? this.minutesBefore,
    );
  }

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    return ReminderSettings(
      enabled: json['enabled'] as bool? ?? false,
      hour: json['hour'] as int? ?? 18,
      minute: json['minute'] as int? ?? 0,
      weekdays: (json['weekdays'] as List<dynamic>? ?? const [])
          .map((e) => e as int)
          .toSet(),
      minutesBefore: json['minutes_before'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'hour': hour,
      'minute': minute,
      'weekdays': weekdays.toList()..sort(), // JSON không có kiểu Set
      'minutes_before': minutesBefore,
    };
  }

  @override
  List<Object?> get props => [enabled, hour, minute, weekdays, minutesBefore];
}
