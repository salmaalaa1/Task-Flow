import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String hashedPassword;

  @HiveField(4)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
