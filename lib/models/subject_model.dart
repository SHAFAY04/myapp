import 'package:flutter/material.dart';

class SubjectModel {
  final String id;
  final String title;
  final String code;
  final String description;
  final String schedule;
  final String room;
  final String instructor;
  final int credits;
  final String icon;
  final List<Color> gradient;

  const SubjectModel({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.schedule,
    required this.room,
    required this.instructor,
    required this.credits,
    required this.icon,
    required this.gradient,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) => SubjectModel(
        id: map['id'] as String,
        title: map['title'] as String,
        code: map['code'] as String,
        description: map['description'] as String,
        schedule: map['schedule'] as String,
        room: map['room'] as String,
        instructor: map['instructor'] as String,
        credits: map['credits'] as int,
        icon: map['icon'] as String,
        gradient: (map['gradient'] as List).cast<Color>(),
      );
}
