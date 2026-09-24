import 'package:stride/core/utils/time_utils.dart';
import 'package:stride/model/phase_model.dart';

class RouteModel {
  final int? id;
  final String title;
  final String description;
  final String goal;
  final String startDate;
  final String endDate;
  final bool isActive;
  final List<PhaseModel> phases;

  RouteModel({
    this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.phases = const [],
  });

  // Chuyển JSON từ API thành Object
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      phases:
          (json['phases'] as List<dynamic>?)
              ?.map((e) => PhaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  RouteModel copyWith({
    int? id,
    String? title,
    String? description,
    String? goal,
    String? startDate,
    String? endDate,
    bool? isActive,
    List<PhaseModel>? phases,
  }) {
    return RouteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      goal: goal ?? this.goal,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      phases: phases ?? this.phases,
    );
  }

  String get durationText {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return TimeUtils.formatDuration(start, end);
    } catch (e) {
      return '0 ngày';
    }
  }
}
