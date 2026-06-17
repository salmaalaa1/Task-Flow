import 'package:flutter/material.dart';

enum TaskPriority { urgent, medium, low }
enum TaskCategory { work, personal, health, study, finance }

class ChecklistItem {
  final String id;
  final String title;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  factory ChecklistItem.fromMap(Map<dynamic, dynamic> map) => ChecklistItem(
        id: map['id'] as String,
        title: map['title'] as String,
        isCompleted: map['isCompleted'] as bool? ?? false,
      );
}

class Task {
  final String id;
  String title;
  String description;
  TaskPriority priority;
  TaskCategory category;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isCompleted;
  List<ChecklistItem> checklist;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.work,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    this.isCompleted = false,
    List<ChecklistItem>? checklist,
    DateTime? createdAt,
  })  : startTime = startTime ?? TimeOfDay.now(),
        endTime = endTime ?? TimeOfDay(hour: (TimeOfDay.now().hour + 1) % 24, minute: TimeOfDay.now().minute),
        checklist = checklist ?? [],
        createdAt = createdAt ?? DateTime.now();

  static String _formatSingleTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get formattedTime {
    return '${_formatSingleTime(startTime)} – ${_formatSingleTime(endTime)}';
  }

  String get formattedStartTime => _formatSingleTime(startTime);
  String get formattedEndTime => _formatSingleTime(endTime);

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.urgent:
        return const Color(0xFFEF4444);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return const Color(0xFF22C55E);
    }
  }

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.urgent:
        return 'Urgent';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  String get categoryLabel {
    switch (category) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.finance:
        return 'Finance';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case TaskCategory.work:
        return Icons.work;
      case TaskCategory.personal:
        return Icons.favorite;
      case TaskCategory.health:
        return Icons.fitness_center;
      case TaskCategory.study:
        return Icons.school;
      case TaskCategory.finance:
        return Icons.payments;
    }
  }

  int get completedChecklistCount =>
      checklist.where((item) => item.isCompleted).length;

  // --- Serialization ---
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.index,
        'category': category.index,
        'startTimeHour': startTime.hour,
        'startTimeMinute': startTime.minute,
        'endTimeHour': endTime.hour,
        'endTimeMinute': endTime.minute,
        'isCompleted': isCompleted,
        'checklist': checklist.map((c) => c.toMap()).toList(),
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Task.fromMap(Map<dynamic, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        priority: TaskPriority.values[map['priority'] as int? ?? 1],
        category: TaskCategory.values[map['category'] as int? ?? 0],
        startTime: TimeOfDay(
          hour: map['startTimeHour'] as int? ?? map['dueTimeHour'] as int? ?? 9,
          minute: map['startTimeMinute'] as int? ?? map['dueTimeMinute'] as int? ?? 0,
        ),
        endTime: TimeOfDay(
          hour: map['endTimeHour'] as int? ?? ((map['dueTimeHour'] as int? ?? 9) + 1) % 24,
          minute: map['endTimeMinute'] as int? ?? map['dueTimeMinute'] as int? ?? 0,
        ),
        isCompleted: map['isCompleted'] as bool? ?? false,
        checklist: (map['checklist'] as List<dynamic>?)
                ?.map((c) => ChecklistItem.fromMap(c as Map<dynamic, dynamic>))
                .toList() ??
            [],
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );
}
