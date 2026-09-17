class PhaseModel {
  final int id;
  final String title;
  final String description;
  final int order;
  final String startDate;
  final String endDate;
  final bool isCompleted;

  PhaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }
}
