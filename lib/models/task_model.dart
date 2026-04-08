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
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isCompleted;
  List<ChecklistItem> checklist;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.work,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    this.isCompleted = false,
    List<ChecklistItem>? checklist,
    DateTime? createdAt,
  })  : dueDate = dueDate ?? DateTime.now(),
        dueTime = dueTime ?? TimeOfDay.now(),
        checklist = checklist ?? [],
        createdAt = createdAt ?? DateTime.now();

  String get formattedTime {
    final hour = dueTime.hourOfPeriod == 0 ? 12 : dueTime.hourOfPeriod;
    final minute = dueTime.minute.toString().padLeft(2, '0');
    final period = dueTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool get isToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  bool get isUpcoming => dueDate.isAfter(DateTime.now()) && !isToday;

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
        'dueDate': dueDate.millisecondsSinceEpoch,
        'dueTimeHour': dueTime.hour,
        'dueTimeMinute': dueTime.minute,
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
        dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
        dueTime: TimeOfDay(
          hour: map['dueTimeHour'] as int? ?? 9,
          minute: map['dueTimeMinute'] as int? ?? 0,
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
