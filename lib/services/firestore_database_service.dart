import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../models/team_task_model.dart';
import '../models/user_model.dart';

enum TeamRole { owner, leader, member }

class FirestoreTeam {
  final String id;
  final String name;
  final String description;
  final String ownerUserId;
  final List<TeamMemberRecord> members;

  const FirestoreTeam({required this.id, required this.name, required this.description, required this.ownerUserId, required this.members});
}

class TeamMemberRecord {
  final String userId;
  final String name;
  final String email;
  final String department;
  final String role;

  const TeamMemberRecord({required this.userId, required this.name, required this.email, required this.department, required this.role});

  Map<String, dynamic> toMap() => {'userId': userId, 'name': name, 'email': email, 'department': department, 'role': role};

  factory TeamMemberRecord.fromMap(Map<String, dynamic> map) =>
      TeamMemberRecord(userId: map['userId'] as String? ?? '', name: map['name'] as String? ?? '', email: map['email'] as String? ?? '', department: map['department'] as String? ?? '', role: map['role'] as String? ?? '');
}

class TeamJoinResponse {
  final bool success;
  final String? message;
  final FirestoreTeam? team;
  final TeamMemberRecord? member;

  const TeamJoinResponse({required this.success, this.message, this.team, this.member});
}

/// Firestore data access for Task Flow.
///
/// Collections:
/// - `users/{uid}`
/// - `teams/{teamId}`
/// - `teams/{teamId}/members/{uid}`
/// - `teams/{teamId}/tasks/{taskId}`
class FirestoreDatabaseService {
  FirestoreDatabaseService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _teams => _db.collection('teams');

  String normalizeTeamName(String value) => value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  String _hashJoinPassword(String password) => sha256.convert(utf8.encode(password.trim())).toString();

  Future<void> createUserProfile({required String uid, required String name, required String email}) async {
    final now = FieldValue.serverTimestamp();
    await _users.doc(uid).set({'uid': uid, 'name': name.trim(), 'email': email.trim().toLowerCase(), 'createdAt': now, 'updatedAt': now}, SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return UserModel(id: uid, name: data['name'] as String? ?? '', email: data['email'] as String? ?? '', hashedPassword: '', createdAt: _dateFromFirestore(data['createdAt']));
  }

  Future<void> updateUserProfile({required String uid, required String name, required String email}) {
    return _users.doc(uid).set({'uid': uid, 'name': name.trim(), 'email': email.trim().toLowerCase(), 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<FirestoreTeam> createTeam({required String name, required String description, required String password, required String ownerUserId, required String ownerName, required String ownerEmail}) async {
    final normalizedName = normalizeTeamName(name);
    final existing = await _teams.where('normalizedName', isEqualTo: normalizedName).limit(1).get();
    if (existing.docs.isNotEmpty) {
      throw StateError('A team with this name already exists.');
    }

    final teamRef = _teams.doc();
    final ownerMember = TeamMemberRecord(userId: ownerUserId, name: ownerName, email: ownerEmail, department: '', role: TeamRole.owner.name);
    final batch = _db.batch();
    batch.set(teamRef, {
      'name': name.trim(),
      'normalizedName': normalizedName,
      'description': description.trim(),
      'joinPasswordHash': _hashJoinPassword(password),
      'ownerUserId': ownerUserId,
      'memberIds': [ownerUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.set(teamRef.collection('members').doc(ownerUserId), {...ownerMember.toMap(), 'joinedAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
    await batch.commit();

    return FirestoreTeam(id: teamRef.id, name: name.trim(), description: description.trim(), ownerUserId: ownerUserId, members: [ownerMember]);
  }

  Future<TeamJoinResponse> joinTeam({required String teamName, required String password, required String userId, required String displayName, required String email, required String department, required TeamRole role}) async {
    final teamQuery = await _teams.where('normalizedName', isEqualTo: normalizeTeamName(teamName)).limit(1).get();
    if (teamQuery.docs.isEmpty) {
      return const TeamJoinResponse(success: false, message: 'No team exists with that name.');
    }

    final teamDoc = teamQuery.docs.first;
    final teamData = teamDoc.data();
    if (teamData['joinPasswordHash'] != _hashJoinPassword(password)) {
      return const TeamJoinResponse(success: false, message: 'The team password is incorrect.');
    }
    if (teamData['ownerUserId'] == userId) {
      return const TeamJoinResponse(success: false, message: 'The team owner cannot join as a member.');
    }

    final memberRef = teamDoc.reference.collection('members').doc(userId);
    final memberDoc = await memberRef.get();
    if (memberDoc.exists) {
      return const TeamJoinResponse(success: false, message: 'This account has already joined this team.');
    }

    final member = TeamMemberRecord(userId: userId, name: displayName.trim(), email: email.trim().toLowerCase(), department: department.trim(), role: role.name);
    await _db.runTransaction((transaction) async {
      transaction.set(memberRef, {...member.toMap(), 'joinedAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
      transaction.update(teamDoc.reference, {
        'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    final members = await getTeamMembers(teamDoc.id);
    return TeamJoinResponse(
      success: true,
      team: FirestoreTeam(id: teamDoc.id, name: teamData['name'] as String? ?? teamName, description: teamData['description'] as String? ?? '', ownerUserId: teamData['ownerUserId'] as String? ?? '', members: members),
      member: member,
    );
  }

  Future<List<TeamMemberRecord>> getTeamMembers(String teamId) async {
    final snapshot = await _teams.doc(teamId).collection('members').orderBy('joinedAt').get();
    return snapshot.docs.map((doc) => TeamMemberRecord.fromMap(doc.data())).toList(growable: false);
  }

  Stream<List<TeamTask>> watchTeamTasks(String teamId) {
    return _teams.doc(teamId).collection('tasks').orderBy('createdAt', descending: true).snapshots().map((snapshot) => snapshot.docs.map(_taskFromDoc).toList(growable: false));
  }

  Stream<List<TeamTask>> watchAssignedTasks({required String teamId, required String userId}) {
    return _teams.doc(teamId).collection('tasks').where('assignedToUserId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots().map((snapshot) => snapshot.docs.map(_taskFromDoc).toList(growable: false));
  }

  Future<void> createTask({required String teamId, required TeamTask task, required String createdByUserId, required String createdByRole}) {
    final taskRef = _teams.doc(teamId).collection('tasks').doc(task.id);
    return taskRef.set({...task.toMap(), 'createdByUserId': createdByUserId, 'createdByRole': createdByRole, 'createdAt': Timestamp.fromDate(task.createdAt), 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<bool> updateAssignedTaskStatus({required String teamId, required String taskId, required String userId, required String status}) async {
    final taskRef = _teams.doc(teamId).collection('tasks').doc(taskId);
    final doc = await taskRef.get();
    if (!doc.exists || doc.data()?['assignedToUserId'] != userId) return false;
    await taskRef.update({'status': status, 'updatedAt': FieldValue.serverTimestamp()});
    return true;
  }

  Future<bool> updateAssignedTaskNote({required String teamId, required String taskId, required String userId, required String note}) async {
    final taskRef = _teams.doc(teamId).collection('tasks').doc(taskId);
    final doc = await taskRef.get();
    if (!doc.exists || doc.data()?['assignedToUserId'] != userId) return false;
    await taskRef.update({'note': note, 'updatedAt': FieldValue.serverTimestamp()});
    return true;
  }

  Future<void> deleteTask({required String teamId, required String taskId}) {
    return _teams.doc(teamId).collection('tasks').doc(taskId).delete();
  }

  TeamTask _taskFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return TeamTask(
      id: doc.id,
      title: data['title'] as String? ?? '',
      note: data['note'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      assignedTo: data['assignedTo'] as String? ?? '',
      assignedToUserId: data['assignedToUserId'] as String? ?? '',
      createdAt: _dateFromFirestore(data['createdAt']),
    );
  }

  DateTime _dateFromFirestore(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }
}
