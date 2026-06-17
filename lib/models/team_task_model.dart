/// A simple team task model with Hive serialization (via Map).
class TeamTask {
  final String id;
  String title;
  String note;
  String status; // 'pending', 'in_progress', 'done', 'late'
  String assignedTo; // member name the task is assigned to
  final DateTime createdAt;

  TeamTask({
    required this.id,
    required this.title,
    this.note = '',
    this.status = 'pending',
    this.assignedTo = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isDone => status == 'done';
  bool get isLate => status == 'late';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'note': note,
        'status': status,
        'assignedTo': assignedTo,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory TeamTask.fromMap(Map<dynamic, dynamic> map) => TeamTask(
        id: map['id'] as String,
        title: map['title'] as String,
        note: map['note'] as String? ?? '',
        status: map['status'] as String? ?? 'pending',
        assignedTo: map['assignedTo'] as String? ?? '',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );
}
