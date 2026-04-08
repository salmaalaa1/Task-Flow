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

  // --- Serialization ---
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'location': location,
        'date': date.millisecondsSinceEpoch,
        'startTimeHour': startTime.hour,
        'startTimeMinute': startTime.minute,
        'endTimeHour': endTime.hour,
        'endTimeMinute': endTime.minute,
        // ignore: deprecated_member_use
        'colorValue': color.value,
        'iconCodePoint': icon.codePoint,
        'iconFontFamily': icon.fontFamily,
      };

  factory Event.fromMap(Map<dynamic, dynamic> map) => Event(
        id: map['id'] as String,
        title: map['title'] as String,
        location: map['location'] as String? ?? '',
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        startTime: TimeOfDay(
          hour: map['startTimeHour'] as int? ?? 9,
          minute: map['startTimeMinute'] as int? ?? 0,
        ),
        endTime: TimeOfDay(
          hour: map['endTimeHour'] as int? ?? 10,
          minute: map['endTimeMinute'] as int? ?? 0,
        ),
        // ignore: deprecated_member_use
        color: Color(map['colorValue'] as int? ?? 0xFF4D41DF),
        icon: IconData(
          map['iconCodePoint'] as int? ?? Icons.event.codePoint,
          fontFamily: map['iconFontFamily'] as String? ?? 'MaterialIcons',
        ),
      );
}
