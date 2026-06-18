import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow_app/providers/team_provider.dart';

void main() {
  late Directory hiveDir;

  setUp(() async {
    hiveDir = await Directory.systemTemp.createTemp('taskflow_team_provider_test_');
    Hive.init(hiveDir.path);
    await Hive.openBox('team');
  });

  tearDown(() async {
    await Hive.box('team').clear();
    await Hive.close();
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  test('joining requires an existing team and matching password', () async {
    final teamProvider = TeamProvider();

    final unknownTeam = await teamProvider.joinTeamAsMember(teamName: 'Design Ops', password: 'secret123', userId: 'TF-123456', department: 'Programming', displayName: 'Mona Ali', email: 'mona@example.com');

    expect(unknownTeam.success, isFalse);
    expect(teamProvider.isInTeam, isFalse);

    await teamProvider.createTeam(teamName: 'Design Ops', description: 'Product design work', password: 'secret123', ownerUserId: 'owner-1', ownerName: 'Owner');
    await teamProvider.clearTeam();

    final wrongPassword = await teamProvider.joinTeamAsMember(teamName: 'Design Ops', password: 'wrong-password', userId: 'TF-123456', department: 'Programming', displayName: 'Mona Ali', email: 'mona@example.com');

    expect(wrongPassword.success, isFalse);
    expect(teamProvider.isInTeam, isFalse);
  });

  test('joining records authenticated account details and blocks duplicates', () async {
    final teamProvider = TeamProvider();
    await teamProvider.createTeam(teamName: 'Content Team', description: 'Content operations', password: 'content-pass', ownerUserId: 'owner-1', ownerName: 'Owner');
    await teamProvider.clearTeam();

    final firstJoin = await teamProvider.joinTeamAsMember(teamName: 'Content Team', password: 'content-pass', userId: 'TF-ABC123', department: 'Media', displayName: 'Salma A.', email: 'salma@example.com');

    expect(firstJoin.success, isTrue);
    expect(teamProvider.isMember, isTrue);
    expect(teamProvider.userId, 'TF-ABC123');
    expect(teamProvider.department, 'Media');

    await teamProvider.clearTeam();

    final duplicateJoin = await teamProvider.joinTeamAsMember(teamName: 'Content Team', password: 'content-pass', userId: 'TF-ABC123', department: 'Media', displayName: 'Salma A.', email: 'salma@example.com');

    expect(duplicateJoin.success, isFalse);
    expect(teamProvider.isInTeam, isFalse);
  });

  test('deleted teams are no longer joinable', () async {
    final teamProvider = TeamProvider();
    await teamProvider.createTeam(teamName: 'Ops Team', description: 'Operations', password: 'ops-pass');
    await teamProvider.clearTeam(deleteTeamRecord: true);

    final joinDeletedTeam = await teamProvider.joinTeamAsMember(teamName: 'Ops Team', password: 'ops-pass', userId: 'TF-777777', department: 'Operation', displayName: 'Omar', email: 'omar@example.com');

    expect(joinDeletedTeam.success, isFalse);
  });
}
