import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _searchQuery = '';
  String _activeFilter = 'All';

  TaskProvider() {
    _seedSampleData();
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
      if (dayTasks.isEmpty) return 0.3 + (i * 0.1); // fallback visual data
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
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleComplete(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void toggleChecklistItem(String taskId, String itemId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final item = task.checklist.firstWhere((c) => c.id == itemId);
    item.isCompleted = !item.isCompleted;
    notifyListeners();
  }

  void updateTask(Task updated) {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _tasks[idx] = updated;
      notifyListeners();
    }
  }

  // --- Seed Data ---
  void _seedSampleData() {
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Q3 Strategy Review',
        description:
            'Complete the final draft of the market expansion analysis and prepare the slide deck for the board meeting.',
        priority: TaskPriority.urgent,
        category: TaskCategory.work,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 10, minute: 0),
        checklist: [
          ChecklistItem(id: 'c1', title: 'Aggregate department KPIs'),
          ChecklistItem(id: 'c2', title: 'Prepare visualization of growth metrics'),
          ChecklistItem(id: 'c3', title: 'Draft executive summary', isCompleted: true),
          ChecklistItem(id: 'c4', title: 'Review with stakeholders'),
        ],
      ),
      Task(
        id: '2',
        title: 'Client Onboarding Flow',
        description:
            'Review the user journey for the new signup process. Check for friction points and optimize conversion.',
        priority: TaskPriority.medium,
        category: TaskCategory.work,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 11, minute: 30),
        checklist: [
          ChecklistItem(id: 'c5', title: 'Map current user journey'),
          ChecklistItem(id: 'c6', title: 'Identify friction points'),
          ChecklistItem(id: 'c7', title: 'Propose improvements'),
        ],
      ),
      Task(
        id: '3',
        title: 'Update Documentation',
        description:
            'Fix typos in the internal wiki and update the software version requirements for all projects.',
        priority: TaskPriority.low,
        category: TaskCategory.work,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 13, minute: 0),
      ),
      Task(
        id: '4',
        title: 'Morning Standup',
        description: 'Daily sync with the engineering team to discuss blockers and progress.',
        priority: TaskPriority.low,
        category: TaskCategory.work,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 9, minute: 0),
        isCompleted: true,
      ),
      Task(
        id: '5',
        title: 'Design Review Meeting',
        description: 'Review the latest design iterations for the mobile app redesign project.',
        priority: TaskPriority.medium,
        category: TaskCategory.work,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 15, minute: 0),
      ),
      Task(
        id: '6',
        title: 'Gym Session',
        description: 'Upper body workout: bench press, rows, shoulder press, and core.',
        priority: TaskPriority.medium,
        category: TaskCategory.health,
        dueDate: now,
        dueTime: const TimeOfDay(hour: 7, minute: 0),
        isCompleted: true,
      ),
      Task(
        id: '7',
        title: 'Read Chapter 5',
        description: 'Continue reading "Designing Data-Intensive Applications" by Martin Kleppmann.',
        priority: TaskPriority.low,
        category: TaskCategory.study,
        dueDate: now.add(const Duration(days: 1)),
        dueTime: const TimeOfDay(hour: 20, minute: 0),
      ),
      Task(
        id: '8',
        title: 'Budget Review',
        description: 'Review monthly spending and update the savings tracker spreadsheet.',
        priority: TaskPriority.medium,
        category: TaskCategory.finance,
        dueDate: now.add(const Duration(days: 2)),
        dueTime: const TimeOfDay(hour: 18, minute: 0),
      ),
      Task(
        id: '9',
        title: 'Call Mom',
        description: 'Weekly check-in call with family.',
        priority: TaskPriority.low,
        category: TaskCategory.personal,
        dueDate: now.add(const Duration(days: 1)),
        dueTime: const TimeOfDay(hour: 19, minute: 0),
      ),
    ]);
  }
}
