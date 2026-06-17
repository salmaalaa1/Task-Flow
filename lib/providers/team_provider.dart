import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Manages team state with Hive persistence.
/// Stores: teamName, description, password, role, department, userId, members list.
class TeamProvider extends ChangeNotifier {
  static const _boxName = 'team';

  // Keys
  static const _kTeamName = 'teamName';
  static const _kDescription = 'description';
  static const _kPassword = 'password';
  static const _kRole = 'role'; // 'owner', 'leader', 'member'
  static const _kDepartment = 'department';
  static const _kUserId = 'userId';
  static const _kMembers = 'members'; // List<String> of member names

  String? _teamName;
  String? _description;
  String? _password;
  String? _role;
  String? _department;
  String? _userId;
  List<String> _members = [];

  TeamProvider() {
    _loadFromHive();
  }

  // --- Getters ---
  String? get teamName => _teamName;
  String? get description => _description;
  String? get password => _password;
  String? get role => _role;
  String? get department => _department;
  String? get userId => _userId;
  List<String> get members => List.unmodifiable(_members);

  bool get isInTeam => _teamName != null && _role != null;
  bool get isOwner => _role == 'owner';
  bool get isLeader => _role == 'leader';
  bool get isMember => _role == 'member';

  // --- Load persisted data ---
  void _loadFromHive() {
    final box = Hive.box(_boxName);
    _teamName = box.get(_kTeamName) as String?;
    _description = box.get(_kDescription) as String?;
    _password = box.get(_kPassword) as String?;
    _role = box.get(_kRole) as String?;
    _department = box.get(_kDepartment) as String?;
    _userId = box.get(_kUserId) as String?;
    final rawMembers = box.get(_kMembers);
    if (rawMembers != null) {
      _members = List<String>.from(rawMembers as List);
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final box = Hive.box(_boxName);
    await box.put(_kTeamName, _teamName);
    await box.put(_kDescription, _description);
    await box.put(_kPassword, _password);
    await box.put(_kRole, _role);
    await box.put(_kDepartment, _department);
    await box.put(_kUserId, _userId);
    await box.put(_kMembers, _members);
  }

  // --- Actions ---

  /// Called when user creates a team (becomes owner).
  Future<void> createTeam({
    required String teamName,
    required String description,
    required String password,
  }) async {
    _teamName = teamName;
    _description = description;
    _password = password;
    _role = 'owner';
    _department = null;
    _userId = null;
    _members = [];
    notifyListeners();
    await _persist();
  }

  /// Called when user joins a team as a member.
  Future<void> joinTeamAsMember({
    required String teamName,
    required String password,
    required String userId,
    required String department,
  }) async {
    _teamName = teamName;
    _description = null;
    _password = password;
    _role = 'member';
    _department = department;
    _userId = userId;
    notifyListeners();
    await _persist();
  }

  /// Called when user joins a team as a leader.
  Future<void> joinTeamAsLeader({
    required String teamName,
    required String password,
    required String userId,
    required String department,
  }) async {
    _teamName = teamName;
    _description = null;
    _password = password;
    _role = 'leader';
    _department = department;
    _userId = userId;
    notifyListeners();
    await _persist();
  }

  // --- Member management (owner only) ---

  /// Add a member name to the team
  void addMember(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _members.contains(trimmed)) return;
    _members.add(trimmed);
    notifyListeners();
    _persist();
  }

  /// Remove a member from the team
  void removeMember(String name) {
    _members.remove(name);
    notifyListeners();
    _persist();
  }

  /// Clears all team data (leave or delete team).
  Future<void> clearTeam() async {
    _teamName = null;
    _description = null;
    _password = null;
    _role = null;
    _department = null;
    _userId = null;
    _members = [];
    notifyListeners();
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
