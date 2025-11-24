import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/models/boarder.dart';
import 'package:my_app/models/payment.dart';
import 'package:my_app/models/additional_fee.dart';

class DatabaseService {
  static const String boardersBoxName = 'boarders';
  static const String paymentsBoxName = 'payments';
  static const String feesBoxName = 'fees';

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BoarderAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PaymentAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AdditionalFeeAdapter());
    }

    await Hive.openBox<Boarder>(boardersBoxName);
    await Hive.openBox<Payment>(paymentsBoxName);
    await Hive.openBox<AdditionalFee>(feesBoxName);
  }

  static Box<Boarder> get boardersBox => Hive.box<Boarder>(boardersBoxName);
  static Box<Payment> get paymentsBox => Hive.box<Payment>(paymentsBoxName);
  static Box<AdditionalFee> get feesBox => Hive.box<AdditionalFee>(feesBoxName);
}
