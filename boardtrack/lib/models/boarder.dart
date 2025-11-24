import 'package:hive/hive.dart';

part 'boarder.g.dart';

@HiveType(typeId: 0)
class Boarder extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String roomNumber;

  @HiveField(2)
  late double monthlyRent;

  @HiveField(3)
  late DateTime createdAt;

  Boarder({
    required this.name,
    required this.roomNumber,
    required this.monthlyRent,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}
