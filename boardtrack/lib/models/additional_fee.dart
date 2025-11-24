import 'package:hive/hive.dart';

part 'additional_fee.g.dart';

@HiveType(typeId: 2)
class AdditionalFee extends HiveObject {
  @HiveField(0)
  late int boarderId;

  @HiveField(1)
  late String feeName;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late DateTime feeDate;

  @HiveField(4)
  late DateTime createdAt;

  AdditionalFee({
    required this.boarderId,
    required this.feeName,
    required this.amount,
    required this.feeDate,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}
