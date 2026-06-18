import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/firestore_database_service.dart';

/// Manages team state with Hive persistence.
/// Stores: teamName, description, password, role, department, userId, members list.
class TeamProvider extends ChangeNotifier {
  TeamProvider({FirestoreDatabaseService? databaseService}) : _databaseService = databaseService {
    _loadFromHive();
  }

  static const _boxName = 'team';
  static const validDepartments = {'Programming', 'Media', 'Operation'};

  // Keys
  static const _kTeamName = 'teamName';
  static const _kDescription = 'description';
  static const _kPassword = 'password';
  static const _kRole = 'role'; // 'owner', 'leader', 'member'
  static const _kDepartment = 'department';
  static const _kUserId = 'userId';
  static const _kMembers = 'members'; // List<String> of member names
  static const _kMemberInfos = 'memberInfos';
  static const _kTeamDirectory = 'teamDirectory';
  static const _kTeamId = 'teamId';

  final FirestoreDatabaseService? _databaseService;

  String? _teamId;
  String? _teamName;
  String? _description;
  String? _password;
  String? _role;
  String? _department;
  String? _userId;
  List<String> _members = [];
  List<TeamMemberInfo> _memberInfos = [];
  Map<String, Map<String, dynamic>> _teamDirectory = {};

  // --- Getters ---
  String? get teamId => _teamId;
  String? get teamName => _teamName;
  String? get description => _description;
  String? get password => _password;
  String? get role => _role;
  String? get department => _department;
  String? get userId => _userId;
  List<String> get members => List.unmodifiable(_members);
  List<TeamMemberInfo> get memberInfos {
    if (_memberInfos.isNotEmpty) return List.unmodifiable(_memberInfos);
    if (_teamName == null) return const [];
    final teamRecord = _teamDirectory[_normalizeTeamName(_teamName!)];
    if (teamRecord == null) return const [];
    return _directoryMembers(teamRecord)
        .map((member) => TeamMemberInfo(userId: member['userId'] ?? '', name: member['name'] ?? '', email: member['email'] ?? '', department: member['department'] ?? '', role: member['role'] ?? ''))
        .where((member) => member.userId.isNotEmpty && member.name.isNotEmpty)
        .toList(growable: false);
  }

  bool get isInTeam => _teamName != null && _role != null;
  bool get isOwner => _role == 'owner';
  bool get isLeader => _role == 'leader';
  bool get isMember => _role == 'member';

  // --- Load persisted data ---
  void _loadFromHive() {
    final box = Hive.box(_boxName);
    _teamId = box.get(_kTeamId) as String?;
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
    final rawMemberInfos = box.get(_kMemberInfos);
    if (rawMemberInfos is List) {
      _memberInfos = rawMemberInfos.map((member) => TeamMemberInfo.fromMap(Map<String, dynamic>.from(member as Map))).toList(growable: false);
    }
    final rawDirectory = box.get(_kTeamDirectory);
    if (rawDirectory != null) {
      _teamDirectory = (rawDirectory as Map).map((key, value) => MapEntry(key as String, Map<String, dynamic>.from(value as Map)));
    }
    if (_teamName != null) {
      final teamRecord = _teamDirectory[_normalizeTeamName(_teamName!)];
      if (teamRecord != null) {
        _memberInfos = _directoryMembers(teamRecord)
            .map((member) => TeamMemberInfo(userId: member['userId'] ?? '', name: member['name'] ?? '', email: member['email'] ?? '', department: member['department'] ?? '', role: member['role'] ?? ''))
            .where((member) => member.userId.isNotEmpty && member.name.isNotEmpty)
            .toList(growable: false);
      }
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final box = Hive.box(_boxName);
    await box.put(_kTeamId, _teamId);
    await box.put(_kTeamName, _teamName);
    await box.put(_kDescription, _description);
    await box.put(_kPassword, _password);
    await box.put(_kRole, _role);
    await box.put(_kDepartment, _department);
    await box.put(_kUserId, _userId);
    await box.put(_kMembers, _members);
    await box.put(_kMemberInfos, _memberInfos.map((member) => member.toMap()).toList());
    await box.put(_kTeamDirectory, _teamDirectory);
  }

  String _normalizeTeamName(String value) => value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  List<Map<String, String>> _directoryMembers(Map<String, dynamic> teamRecord) {
    final rawMembers = teamRecord['members'];
    if (rawMembers is! List) return [];
    return rawMembers.map((member) => Map<String, String>.from(member as Map)).toList();
  }

  bool teamExists(String teamName) => _teamDirectory.containsKey(_normalizeTeamName(teamName));

  bool passwordMatchesTeam({required String teamName, required String password}) {
    final teamRecord = _teamDirectory[_normalizeTeamName(teamName)];
    return teamRecord != null && teamRecord['password'] == password;
  }

  // --- Actions ---

  /// Called when user creates a team (becomes owner).
  Future<void> createTeam({required String teamName, required String description, required String password, String? ownerUserId, String? ownerName, String? ownerEmail}) async {
    final normalizedName = teamName.trim().replaceAll(RegExp(r'\s+'), ' ');
    final normalizedDescription = description.trim();
    final normalizedPassword = password.trim();

    if (_databaseService != null) {
      if (ownerUserId == null || ownerUserId.trim().isEmpty) {
        throw StateError('You must be signed in to create a team.');
      }
      final team = await _databaseService.createTeam(name: normalizedName, description: normalizedDescription, password: normalizedPassword, ownerUserId: ownerUserId, ownerName: ownerName ?? 'Owner', ownerEmail: ownerEmail ?? '');
      _teamId = team.id;
      _teamName = team.name;
      _description = team.description;
      _password = null;
      _role = 'owner';
      _department = null;
      _userId = ownerUserId;
      _members = team.members.map((member) => member.name).where((name) => name.isNotEmpty).toList();
      _memberInfos = team.members.map((member) => TeamMemberInfo(userId: member.userId, name: member.name, email: member.email, department: member.department, role: member.role)).toList(growable: false);
      notifyListeners();
      await _persist();
      return;
    }

    _teamName = normalizedName;
    _description = normalizedDescription;
    _password = normalizedPassword;
    _role = 'owner';
    _department = null;
    _userId = null;
    _members = [];
    _teamDirectory[_normalizeTeamName(normalizedName)] = {
      'teamName': normalizedName,
      'description': normalizedDescription,
      'password': normalizedPassword,
      'ownerUserId': ownerUserId,
      'ownerName': ownerName,
      'members': <Map<String, String>>[],
    };
    notifyListeners();
    await _persist();
  }

  /// Called when user joins a team as a member.
  Future<TeamJoinResult> joinTeamAsMember({required String teamName, required String password, required String userId, required String department, required String displayName, required String email}) async {
    return _joinTeam(teamName: teamName, password: password, userId: userId, department: department, displayName: displayName, email: email, role: 'member');
  }

  /// Called when user joins a team as a leader.
  Future<TeamJoinResult> joinTeamAsLeader({required String teamName, required String password, required String userId, required String department, required String displayName, required String email}) async {
    return _joinTeam(teamName: teamName, password: password, userId: userId, department: department, displayName: displayName, email: email, role: 'leader');
  }

  Future<TeamJoinResult> _joinTeam({required String teamName, required String password, required String userId, required String department, required String displayName, required String email, required String role}) async {
    final normalizedName = teamName.trim().replaceAll(RegExp(r'\s+'), ' ');
    final normalizedPassword = password.trim();
    final normalizedUserId = userId.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedDepartment = department.trim();

    if (normalizedName.isEmpty || normalizedPassword.isEmpty || normalizedUserId.isEmpty || normalizedDisplayName.isEmpty || normalizedEmail.isEmpty) {
      return const TeamJoinResult(false, 'All join fields are required.');
    }
    if (!validDepartments.contains(normalizedDepartment)) {
      return const TeamJoinResult(false, 'Select a valid department.');
    }
    if (!RegExp(r'^TF-[A-Za-z0-9-]{6,}$').hasMatch(normalizedUserId)) {
      return const TeamJoinResult(false, 'Use a valid TaskFlow user ID.');
    }
    if (!RegExp(r'^[\w\.\-\+]+@[\w\-]+\.\w{2,}$').hasMatch(normalizedEmail)) {
      return const TeamJoinResult(false, 'Use a valid account email.');
    }

    if (_databaseService != null) {
      final response = await _databaseService.joinTeam(
        teamName: normalizedName,
        password: normalizedPassword,
        userId: normalizedUserId,
        displayName: normalizedDisplayName,
        email: normalizedEmail,
        department: normalizedDepartment,
        role: role == 'leader' ? TeamRole.leader : TeamRole.member,
      );
      if (!response.success || response.team == null) {
        return TeamJoinResult(false, response.message ?? 'Unable to join team.');
      }
      _teamId = response.team!.id;
      _teamName = response.team!.name;
      _description = response.team!.description;
      _password = null;
      _role = role;
      _department = normalizedDepartment;
      _userId = normalizedUserId;
      _members = response.team!.members.map((member) => member.name).where((name) => name.isNotEmpty).toList();
      _memberInfos = response.team!.members.map((member) => TeamMemberInfo(userId: member.userId, name: member.name, email: member.email, department: member.department, role: member.role)).toList(growable: false);
      notifyListeners();
      await _persist();
      return const TeamJoinResult(true);
    }

    final teamRecord = _teamDirectory[_normalizeTeamName(normalizedName)];
    if (teamRecord == null) {
      return const TeamJoinResult(false, 'No team exists with that name.');
    }
    if (teamRecord['password'] != normalizedPassword) {
      return const TeamJoinResult(false, 'The team password is incorrect.');
    }
    if (teamRecord['ownerUserId'] == normalizedUserId) {
      return const TeamJoinResult(false, 'The team owner cannot join as a member.');
    }

    final directoryMembers = _directoryMembers(teamRecord);
    final alreadyJoined = directoryMembers.any((member) => member['userId'] == normalizedUserId || member['email'] == normalizedEmail);
    if (alreadyJoined) {
      return const TeamJoinResult(false, 'This account has already joined this team.');
    }

    directoryMembers.add({'userId': normalizedUserId, 'name': normalizedDisplayName, 'email': normalizedEmail, 'department': normalizedDepartment, 'role': role});
    teamRecord['members'] = directoryMembers;

    _teamName = teamRecord['teamName'] as String;
    _description = teamRecord['description'] as String?;
    _password = normalizedPassword;
    _role = role;
    _department = normalizedDepartment;
    _userId = normalizedUserId;
    _members = directoryMembers.map((member) => member['name']!).toList();
    notifyListeners();
    await _persist();
    return const TeamJoinResult(true);
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
  Future<void> clearTeam({bool deleteTeamRecord = false}) async {
    final currentTeamKey = _teamName == null ? null : _normalizeTeamName(_teamName!);
    _teamId = null;
    _teamName = null;
    _description = null;
    _password = null;
    _role = null;
    _department = null;
    _userId = null;
    _members = [];
    _memberInfos = [];
    if (deleteTeamRecord && currentTeamKey != null) {
      _teamDirectory.remove(currentTeamKey);
    }
    notifyListeners();
    await _persist();
  }
}

class TeamJoinResult {
  final bool success;
  final String? message;

  const TeamJoinResult(this.success, [this.message]);
}

class TeamMemberInfo {
  final String userId;
  final String name;
  final String email;
  final String department;
  final String role;

  const TeamMemberInfo({required this.userId, required this.name, required this.email, required this.department, required this.role});

  Map<String, dynamic> toMap() => {'userId': userId, 'name': name, 'email': email, 'department': department, 'role': role};

  factory TeamMemberInfo.fromMap(Map<String, dynamic> map) =>
      TeamMemberInfo(userId: map['userId'] as String? ?? '', name: map['name'] as String? ?? '', email: map['email'] as String? ?? '', department: map['department'] as String? ?? '', role: map['role'] as String? ?? '');
}
