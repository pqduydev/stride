class ScheduleModel {
  final String id;
  final String title;
  final String time;
  final String reminderTime;
  final DateTime date;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.time,
    required this.reminderTime,
    required this.date,
  });
}

// enum DifficultyEnum {
//   easy('easy', 'Nhẹ'),
//   medium('medium', 'Vừa'),
//   hard('hard', 'Nặng');

//   final String value;
//   final String label;

//   const DifficultyEnum(this.value, this.label);

//   static DifficultyEnum? fromValue(String? value) {
//     if (value == null) return null;
//     return DifficultyEnum.values.firstWhere(
//       (e) => e.value == value,
//       orElse: () => DifficultyEnum.easy,
//     );
//   }
// }

// class ScheduleModel {
//   final int? id;
//   final String? user;
//   final String? title;
//   final String? description;
//   final String? date;
//   final String? startTime;
//   final String? endTime;
//   final DifficultyEnum? difficulty;
//   final bool? isCompleted;
//   final String? notes;
//   final String? createdAt;
//   final String? updatedAt;

//   ScheduleModel({
//     this.id,
//     this.user,
//     this.title,
//     this.description,
//     this.date,
//     this.startTime,
//     this.endTime,
//     this.difficulty,
//     this.isCompleted,
//     this.notes,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory ScheduleModel.fromJson(Map<String, dynamic> json) {
//     return ScheduleModel(
//       id: json['id'] as int?,
//       user: json['user'] as String?,
//       title: json['title'] as String?,
//       description: json['description'] as String?,
//       date: json['date'] as String?,
//       startTime: json['start_time'] as String?,
//       endTime: json['end_time'] as String?,
//       difficulty: DifficultyEnum.fromValue(json['difficulty'] as String?),
//       isCompleted: json['is_completed'] as bool?,
//       notes: json['notes'] as String?,
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) 'id': id,
//       if (user != null) 'user': user,
//       if (title != null) 'title': title,
//       if (description != null) 'description': description,
//       if (date != null) 'date': date,
//       if (startTime != null) 'start_time': startTime,
//       if (endTime != null) 'end_time': endTime,
//       if (difficulty != null) 'difficulty': difficulty!.value,
//       if (isCompleted != null) 'is_completed': isCompleted,
//       if (notes != null) 'notes': notes,
//       if (createdAt != null) 'created_at': createdAt,
//       if (updatedAt != null) 'updated_at': updatedAt,
//     };
//   }

//   ScheduleModel copyWith({
//     int? id,
//     String? user,
//     String? title,
//     String? description,
//     String? date,
//     String? startTime,
//     String? endTime,
//     DifficultyEnum? difficulty,
//     bool? isCompleted,
//     String? notes,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     return ScheduleModel(
//       id: id ?? this.id,
//       user: user ?? this.user,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       date: date ?? this.date,
//       startTime: startTime ?? this.startTime,
//       endTime: endTime ?? this.endTime,
//       difficulty: difficulty ?? this.difficulty,
//       isCompleted: isCompleted ?? this.isCompleted,
//       notes: notes ?? this.notes,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }
