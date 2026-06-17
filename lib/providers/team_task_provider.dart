import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/team_task_model.dart';

/// Manages team tasks with Hive persistence — same pattern as TaskProvider.
class TeamTaskProvider extends ChangeNotifier {
  static const _boxName = 'team_tasks';

  List<TeamTask> _tasks = [];

  TeamTaskProvider() {
    _loadFromHive();
  }

  // --- Load persisted data ---
  void _loadFromHive() {
    final box = Hive.box(_boxName);
    _tasks = box.values
        .map((raw) => TeamTask.fromMap(Map<dynamic, dynamic>.from(raw as Map)))
        .toList();
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> _persist() async {
    final box = Hive.box(_boxName);
    await box.clear();
    for (final task in _tasks) {
      await box.put(task.id, task.toMap());
    }
  }

  // --- Getters (ALL tasks) ---
  List<TeamTask> get allTasks => List.unmodifiable(_tasks);
  List<TeamTask> get pendingTasks =>
      _tasks.where((t) => !t.isDone).toList();
  List<TeamTask> get completedTasks =>
      _tasks.where((t) => t.isDone).toList();

  int get totalCount => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;

  double get completionRate =>
      _tasks.isEmpty ? 0 : completedCount / totalCount;

  // --- Getters (filtered by assignee) ---
  List<TeamTask> tasksFor(String memberName) =>
      _tasks.where((t) => t.assignedTo == memberName).toList();

  List<TeamTask> pendingTasksFor(String memberName) =>
      _tasks.where((t) => t.assignedTo == memberName && !t.isDone).toList();

  List<TeamTask> completedTasksFor(String memberName) =>
      _tasks.where((t) => t.assignedTo == memberName && t.isDone).toList();

  /// Get unique list of assignee names from existing tasks
  List<String> get assigneeNames {
    final names = _tasks
        .map((t) => t.assignedTo)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    names.sort();
    return names;
  }

  // --- Actions ---
  void addTask(TeamTask task) {
    _tasks.insert(0, task);
    notifyListeners();
    _persist();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    _persist();
  }

  void toggleStatus(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    if (task.isDone) {
      task.status = 'pending';
    } else {
      task.status = 'done';
    }
    notifyListeners();
    _persist();
  }

  void updateNote(String id, String note) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.note = note;
    notifyListeners();
    _persist();
  }

  void setStatus(String id, String status) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.status = status;
    notifyListeners();
    _persist();
  }

  /// Clear all tasks (when team is deleted/left)
  Future<void> clearAll() async {
    _tasks.clear();
    notifyListeners();
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
