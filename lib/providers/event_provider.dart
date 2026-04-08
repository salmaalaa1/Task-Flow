import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  static const _boxName = 'events';
  List<Event> _events = [];
  DateTime _selectedDate = DateTime.now();

  EventProvider() {
    _loadFromHive();
  }

  // --- Load persisted data ---
  Future<void> _loadFromHive() async {
    final box = Hive.box(_boxName);
    _events = box.values
        .map((raw) => Event.fromMap(Map<dynamic, dynamic>.from(raw as Map)))
        .toList();
    notifyListeners();
  }

  Future<void> _persist() async {
    final box = Hive.box(_boxName);
    await box.clear();
    for (final event in _events) {
      await box.put(event.id, event.toMap());
    }
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
    _persist();
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
    _persist();
  }
}
