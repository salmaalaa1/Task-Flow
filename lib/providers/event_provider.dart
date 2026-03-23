import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  DateTime _selectedDate = DateTime.now();

  EventProvider() {
    _seedSampleData();
  }

  List<Event> get allEvents => List.unmodifiable(_events);
  DateTime get selectedDate => _selectedDate;

  List<Event> get eventsForSelectedDate =>
      _events.where((e) => e.isOnDate(_selectedDate)).toList()
        ..sort((a, b) => a.startTime.hour * 60 + a.startTime.minute -
            (b.startTime.hour * 60 + b.startTime.minute));

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _seedSampleData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _events.addAll([
      Event(
        id: 'e1',
        title: 'Team Retrospective',
        location: 'Conference Room A',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        color: const Color(0xFF4D41DF),
        icon: Icons.groups,
      ),
      Event(
        id: 'e2',
        title: 'Product Demo',
        location: 'Virtual - Zoom',
        date: today,
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
        color: const Color(0xFFAC2649),
        icon: Icons.present_to_all,
      ),
      Event(
        id: 'e3',
        title: 'One-on-One with Sarah',
        location: "Manager's Office",
        date: today,
        startTime: const TimeOfDay(hour: 16, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 30),
        color: const Color(0xFF7C3AED),
        icon: Icons.person,
      ),
      Event(
        id: 'e4',
        title: 'Sprint Planning',
        location: 'Conference Room B',
        date: today.add(const Duration(days: 1)),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        color: const Color(0xFF059669),
        icon: Icons.dashboard_customize,
      ),
      Event(
        id: 'e5',
        title: 'Design Workshop',
        location: 'Workshop Room',
        date: today.add(const Duration(days: 2)),
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
        color: const Color(0xFFF59E0B),
        icon: Icons.palette,
      ),
    ]);
  }
}
