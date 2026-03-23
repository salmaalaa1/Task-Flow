import 'package:flutter/material.dart';

class Event {
  final String id;
  String title;
  String location;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Color color;
  IconData icon;

  Event({
    required this.id,
    required this.title,
    this.location = '',
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    this.color = const Color(0xFF4D41DF),
    this.icon = Icons.event,
  })  : date = date ?? DateTime.now(),
        startTime = startTime ?? const TimeOfDay(hour: 9, minute: 0),
        endTime = endTime ?? const TimeOfDay(hour: 10, minute: 0);

  String get formattedTimeRange {
    String fmt(TimeOfDay t) {
      final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final m = t.minute.toString().padLeft(2, '0');
      final p = t.period == DayPeriod.am ? 'AM' : 'PM';
      return '$h:$m $p';
    }
    return '${fmt(startTime)} - ${fmt(endTime)}';
  }

  bool isOnDate(DateTime d) =>
      date.year == d.year && date.month == d.month && date.day == d.day;
}
