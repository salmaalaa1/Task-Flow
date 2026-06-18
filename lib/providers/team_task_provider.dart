import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/team_task_model.dart';
import '../services/firestore_database_service.dart';

/// Manages team tasks with Hive persistence — same pattern as TaskProvider.
class TeamTaskProvider extends ChangeNotifier {
  TeamTaskProvider({FirestoreDatabaseService? databaseService}) : _databaseService = databaseService {
    _loadFromHive();
  }

  static const _boxName = 'team_tasks';

  final FirestoreDatabaseService? _databaseService;
  List<TeamTask> _tasks = [];
  StreamSubscription<List<TeamTask>>? _taskSub;
  String? _teamId;
  String? _assignedToUserId;
  String? _createdByUserId;
  String? _createdByRole;

  bool get _usesFirestore => _databaseService != null && _teamId != null;
  FirestoreDatabaseService get _firestore => _databaseService!;
  String get _activeTeamId => _teamId!;

  // --- Load persisted data ---
  void _loadFromHive() {
    final box = Hive.box(_boxName);
    _tasks = box.values.map((raw) => TeamTask.fromMap(Map<dynamic, dynamic>.from(raw as Map))).toList();
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
  List<TeamTask> get pendingTasks => _tasks.where((t) => !t.isDone).toList();
  List<TeamTask> get completedTasks => _tasks.where((t) => t.isDone).toList();

  int get totalCount => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;

  double get completionRate => _tasks.isEmpty ? 0 : completedCount / totalCount;

  // --- Getters (filtered by assignee) ---
  List<TeamTask> tasksFor(String memberName) => _tasks.where((t) => t.assignedTo == memberName).toList();

  List<TeamTask> pendingTasksFor(String memberName) => _tasks.where((t) => t.assignedTo == memberName && !t.isDone).toList();

  List<TeamTask> completedTasksFor(String memberName) => _tasks.where((t) => t.assignedTo == memberName && t.isDone).toList();

  List<TeamTask> tasksForUser(String userId, {String? fallbackName}) {
    final normalizedUserId = userId.trim();
    final normalizedName = fallbackName?.trim();
    return _tasks.where((task) {
      if (task.assignedToUserId.isNotEmpty) {
        return task.assignedToUserId == normalizedUserId;
      }
      return normalizedName != null && normalizedName.isNotEmpty && task.assignedTo == normalizedName;
    }).toList();
  }

  /// Get unique list of assignee names from existing tasks
  List<String> get assigneeNames {
    final names = _tasks.map((t) => t.assignedTo).where((n) => n.isNotEmpty).toSet().toList();
    names.sort();
    return names;
  }

  // --- Actions ---
  void watchTeamTasks({required String? teamId, String? assignedToUserId, String? createdByUserId, String? createdByRole}) {
    if (_databaseService == null || teamId == null || teamId.isEmpty) return;
    if (_teamId == teamId && _assignedToUserId == assignedToUserId && _createdByUserId == createdByUserId && _createdByRole == createdByRole) return;
    _teamId = teamId;
    _assignedToUserId = assignedToUserId;
    _createdByUserId = createdByUserId;
    _createdByRole = createdByRole;
    _taskSub?.cancel();
    final stream = assignedToUserId == null || assignedToUserId.isEmpty ? _firestore.watchTeamTasks(teamId) : _firestore.watchAssignedTasks(teamId: teamId, userId: assignedToUserId);
    _taskSub = stream.listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  void addTask(TeamTask task) {
    if (_usesFirestore) {
      _firestore.createTask(teamId: _activeTeamId, task: task, createdByUserId: _createdByUserId ?? '', createdByRole: _createdByRole ?? '');
      return;
    }
    _tasks.insert(0, task);
    notifyListeners();
    _persist();
  }

  void deleteTask(String id) {
    if (_usesFirestore) {
      _firestore.deleteTask(teamId: _activeTeamId, taskId: id);
      return;
    }
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

  bool toggleStatusForUser(String id, String userId, {String? fallbackName}) {
    final task = _taskForUser(id, userId, fallbackName: fallbackName);
    if (task == null) return false;
    final nextStatus = task.isDone ? 'pending' : 'done';
    if (_usesFirestore) {
      _firestore.updateAssignedTaskStatus(teamId: _activeTeamId, taskId: id, userId: userId, status: nextStatus);
      return true;
    }
    if (task.isDone) {
      task.status = 'pending';
    } else {
      task.status = 'done';
    }
    notifyListeners();
    _persist();
    return true;
  }

  void updateNote(String id, String note) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.note = note;
    notifyListeners();
    _persist();
  }

  bool updateNoteForUser(String id, String userId, String note, {String? fallbackName}) {
    final task = _taskForUser(id, userId, fallbackName: fallbackName);
    if (task == null) return false;
    if (_usesFirestore) {
      _firestore.updateAssignedTaskNote(teamId: _activeTeamId, taskId: id, userId: userId, note: note);
      return true;
    }
    task.note = note;
    notifyListeners();
    _persist();
    return true;
  }

  void setStatus(String id, String status) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.status = status;
    notifyListeners();
    _persist();
  }

  /// Clear all tasks (when team is deleted/left)
  Future<void> clearAll() async {
    if (_usesFirestore) {
      _tasks.clear();
      notifyListeners();
      return;
    }
    _tasks.clear();
    notifyListeners();
    final box = Hive.box(_boxName);
    await box.clear();
  }

  TeamTask? _taskForUser(String id, String userId, {String? fallbackName}) {
    final normalizedUserId = userId.trim();
    final normalizedName = fallbackName?.trim();
    for (final task in _tasks) {
      if (task.id != id) continue;
      if (task.assignedToUserId.isNotEmpty) {
        return task.assignedToUserId == normalizedUserId ? task : null;
      }
      if (normalizedName != null && normalizedName.isNotEmpty && task.assignedTo == normalizedName) {
        return task;
      }
      return null;
    }
    return null;
  }

  @override
  void dispose() {
    _taskSub?.cancel();
    super.dispose();
  }
}
