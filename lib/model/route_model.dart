import 'package:flutter/material.dart';

class RouteModel {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String startDate;
  final String endDate;
  final String description;

  RouteModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  RouteModel copyWith({
    String? id,
    String? title,
    String? category,
    String? duration,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return RouteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }
}
