import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  static const _boxName = 'tasks';
  List<Task> _tasks = [];
  String _searchQuery = '';
  String _activeFilter = 'All';

  TaskProvider() {
    _loadFromHive();
  }

  // --- Load persisted data ---
  Future<void> _loadFromHive() async {
    final box = Hive.box(_boxName);
    _tasks = box.values
        .map((raw) => Task.fromMap(Map<dynamic, dynamic>.from(raw as Map)))
        .toList();
    // Sort by creation date (newest first)
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

  // --- Getters ---
  List<Task> get allTasks => List.unmodifiable(_tasks);

  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;

  List<Task> get filteredTasks {
    var tasks = _tasks.toList();

    // Apply filter
    switch (_activeFilter) {
      case 'Today':
        tasks = tasks.where((t) => t.isToday).toList();
        break;
      case 'Upcoming':
        tasks = tasks.where((t) => t.isUpcoming && !t.isCompleted).toList();
        break;
      case 'Done':
        tasks = tasks.where((t) => t.isCompleted).toList();
        break;
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tasks = tasks
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q) ||
              t.categoryLabel.toLowerCase().contains(q))
          .toList();
    }

    // Sort: incomplete first, then by priority, then by time
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      final priorityOrder = {
        TaskPriority.urgent: 0,
        TaskPriority.medium: 1,
        TaskPriority.low: 2,
      };
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });

    return tasks;
  }

  List<Task> get todayTasks => _tasks.where((t) => t.isToday).toList();

  List<Task> get urgentTasks =>
      _tasks.where((t) => t.priority == TaskPriority.urgent && !t.isCompleted).toList();

  List<Task> get priorityTasks =>
      _tasks.where((t) => !t.isCompleted).toList()
        ..sort((a, b) {
          final p = {TaskPriority.urgent: 0, TaskPriority.medium: 1, TaskPriority.low: 2};
          return p[a.priority]!.compareTo(p[b.priority]!);
        });

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  double get completionRate =>
      _tasks.isEmpty ? 0 : completedCount / totalCount;

  int taskCountForCategory(TaskCategory category) =>
      _tasks.where((t) => t.category == category).length;

  /// Weekly completion data for the performance chart (last 5 weekdays)
  List<double> get weeklyCompletion {
    final now = DateTime.now();
    return List.generate(5, (i) {
      final day = now.subtract(Duration(days: 4 - i));
      final dayTasks = _tasks.where((t) =>
          t.dueDate.year == day.year &&
          t.dueDate.month == day.month &&
          t.dueDate.day == day.day);
      if (dayTasks.isEmpty) return 0.0;
      return dayTasks.where((t) => t.isCompleted).length / dayTasks.length;
    });
  }

  // --- Actions ---
  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
    _persist();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    _persist();
  }

  void toggleComplete(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
    _persist();
  }

  void toggleChecklistItem(String taskId, String itemId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final item = task.checklist.firstWhere((c) => c.id == itemId);
    item.isCompleted = !item.isCompleted;
    notifyListeners();
    _persist();
  }

  void updateTask(Task updated) {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _tasks[idx] = updated;
      notifyListeners();
      _persist();
    }
  }
}
