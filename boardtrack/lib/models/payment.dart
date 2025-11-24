import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 1)
class Payment extends HiveObject {
  @HiveField(0)
  late int boarderId;

  @HiveField(1)
  late int month;

  @HiveField(2)
  late int year;

  @HiveField(3)
  late bool isPaid;

  @HiveField(4)
  late DateTime? paidDate;

  @HiveField(5)
  late DateTime createdAt;

  Payment({
    required this.boarderId,
    required this.month,
    required this.year,
    required this.isPaid,
    this.paidDate,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}
