import 'package:flutter/material.dart';

class Task {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
  });
}

enum Priority {
  low,
  medium,
  high;

  // Метод для получения цвета
  Color get color {
    switch (this) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Метод для получения текстового описания
  String get text {
    switch (this) {
      case Priority.low:
        return 'Низкий';
      case Priority.medium:
        return 'Средний';
      case Priority.high:
        return 'Высокий';
      default:
        return 'Неизвестно';
    }
  }
}
