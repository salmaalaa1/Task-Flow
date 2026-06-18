import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow_app/models/team_task_model.dart';
import 'package:taskflow_app/providers/team_task_provider.dart';

void main() {
  late Directory hiveDir;

  setUp(() async {
    hiveDir = await Directory.systemTemp.createTemp('taskflow_team_task_provider_test_');
    Hive.init(hiveDir.path);
    await Hive.openBox('team_tasks');
  });

  tearDown(() async {
    await Hive.box('team_tasks').clear();
    await Hive.close();
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  test('tasksForUser only returns tasks assigned to that authenticated user id', () async {
    final provider = TeamTaskProvider();

    provider.addTask(TeamTask(id: 'task-1', title: 'Private for Salma', assignedTo: 'Salma', assignedToUserId: 'TF-SALMA1'));
    provider.addTask(TeamTask(id: 'task-2', title: 'Private for Mona', assignedTo: 'Mona', assignedToUserId: 'TF-MONA1'));

    final salmaTasks = provider.tasksForUser('TF-SALMA1', fallbackName: 'Salma');

    expect(salmaTasks, hasLength(1));
    expect(salmaTasks.single.id, 'task-1');
    await _settleHiveWrites();
  });

  test('member status and note updates are blocked for tasks assigned to another user', () async {
    final provider = TeamTaskProvider();
    provider.addTask(TeamTask(id: 'task-1', title: 'Private for Salma', assignedTo: 'Salma', assignedToUserId: 'TF-SALMA1'));
    provider.addTask(TeamTask(id: 'task-2', title: 'Private for Mona', assignedTo: 'Mona', assignedToUserId: 'TF-MONA1'));

    final blockedToggle = provider.toggleStatusForUser('task-2', 'TF-SALMA1', fallbackName: 'Salma');
    final blockedNote = provider.updateNoteForUser('task-2', 'TF-SALMA1', 'Should not save', fallbackName: 'Salma');
    final allowedToggle = provider.toggleStatusForUser('task-1', 'TF-SALMA1', fallbackName: 'Salma');
    final allowedNote = provider.updateNoteForUser('task-1', 'TF-SALMA1', 'Done from my account', fallbackName: 'Salma');

    final salmaTask = provider.allTasks.singleWhere((task) => task.id == 'task-1');
    final monaTask = provider.allTasks.singleWhere((task) => task.id == 'task-2');

    expect(blockedToggle, isFalse);
    expect(blockedNote, isFalse);
    expect(allowedToggle, isTrue);
    expect(allowedNote, isTrue);
    expect(salmaTask.isDone, isTrue);
    expect(salmaTask.note, 'Done from my account');
    expect(monaTask.isDone, isFalse);
    expect(monaTask.note, isEmpty);
    await _settleHiveWrites();
  });

  test('legacy name-only tasks remain visible only to the matching user name', () async {
    final provider = TeamTaskProvider();
    provider.addTask(TeamTask(id: 'legacy-1', title: 'Old task', assignedTo: 'Salma'));

    expect(provider.tasksForUser('TF-SALMA1', fallbackName: 'Salma'), hasLength(1));
    expect(provider.tasksForUser('TF-MONA1', fallbackName: 'Mona'), isEmpty);
    await _settleHiveWrites();
  });
}

Future<void> _settleHiveWrites() => Future<void>.delayed(const Duration(milliseconds: 50));
