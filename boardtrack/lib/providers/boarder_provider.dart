import 'package:flutter/foundation.dart';
import 'package:my_app/models/boarder.dart';
import 'package:my_app/models/payment.dart';
import 'package:my_app/models/additional_fee.dart';
import 'package:my_app/services/database_service.dart';

class BoarderProvider extends ChangeNotifier {
  List<Boarder> _boarders = [];
  List<Payment> _payments = [];
  List<AdditionalFee> _fees = [];

  List<Boarder> get boarders => _boarders;
  List<Payment> get payments => _payments;
  List<AdditionalFee> get fees => _fees;

  BoarderProvider() {
    _loadData();
  }

  void _loadData() {
    _boarders = DatabaseService.boardersBox.values.toList();
    _payments = DatabaseService.paymentsBox.values.toList();
    _fees = DatabaseService.feesBox.values.toList();
  }

  Future<void> addBoarder(String name, String roomNumber, double monthlyRent) async {
    final boarder = Boarder(
      name: name,
      roomNumber: roomNumber,
      monthlyRent: monthlyRent,
    );
    await DatabaseService.boardersBox.add(boarder);
    _loadData();
    notifyListeners();
  }

  Future<void> deleteBoarder(int index) async {
    if (index >= 0 && index < _boarders.length) {
      await _boarders[index].delete();
      _loadData();
      notifyListeners();
    }
  }

  Future<void> updateBoarder(int index, String name, String roomNumber, double monthlyRent) async {
    if (index >= 0 && index < _boarders.length) {
      final boarder = _boarders[index];
      boarder.name = name;
      boarder.roomNumber = roomNumber;
      boarder.monthlyRent = monthlyRent;
      await boarder.save();
      _loadData();
      notifyListeners();
    }
  }

  Future<void> addPayment(int boarderId, int month, int year, bool isPaid) async {
    final existing = _payments.where((p) => 
      p.boarderId == boarderId && p.month == month && p.year == year
    ).toList();

    if (existing.isNotEmpty) {
      existing.first.isPaid = isPaid;
      existing.first.paidDate = isPaid ? DateTime.now() : null;
      await existing.first.save();
    } else {
      final payment = Payment(
        boarderId: boarderId,
        month: month,
        year: year,
        isPaid: isPaid,
        paidDate: isPaid ? DateTime.now() : null,
      );
      await DatabaseService.paymentsBox.add(payment);
    }
    _loadData();
    notifyListeners();
  }

  bool isPaymentPaid(int boarderId, int month, int year) {
    final payment = _payments.firstWhere(
      (p) => p.boarderId == boarderId && p.month == month && p.year == year,
      orElse: () => Payment(
        boarderId: boarderId,
        month: month,
        year: year,
        isPaid: false,
      ),
    );
    return payment.isPaid;
  }

  Future<void> addFee(int boarderId, String feeName, double amount, DateTime feeDate) async {
    final fee = AdditionalFee(
      boarderId: boarderId,
      feeName: feeName,
      amount: amount,
      feeDate: feeDate,
    );
    await DatabaseService.feesBox.add(fee);
    _loadData();
    notifyListeners();
  }

  Future<void> deleteFee(int index) async {
    if (index >= 0 && index < _fees.length) {
      await _fees[index].delete();
      _loadData();
      notifyListeners();
    }
  }

  List<AdditionalFee> getFeesForBoarder(int boarderId) {
    return _fees.where((f) => f.boarderId == boarderId).toList();
  }

  double getTotalUnpaidRent(int month, int year) {
    double total = 0;
    for (var boarder in _boarders) {
      if (!isPaymentPaid(boarder.key, month, year)) {
        total += boarder.monthlyRent;
      }
    }
    return total;
  }

  double getTotalRentCollected(int month, int year) {
    double total = 0;
    for (var boarder in _boarders) {
      if (isPaymentPaid(boarder.key, month, year)) {
        total += boarder.monthlyRent;
      }
    }
    return total;
  }

  int getUnpaidBoardersCount(int month, int year) {
    int count = 0;
    for (var boarder in _boarders) {
      if (!isPaymentPaid(boarder.key, month, year)) {
        count++;
      }
    }
    return count;
  }

  double getTotalFees(int month, int year) {
    return _fees
      .where((f) => f.feeDate.month == month && f.feeDate.year == year)
      .fold(0, (sum, f) => sum + f.amount);
  }

  double getBoarderBalance(int boarderId, int month, int year) {
    double balance = 0;
    
    try {
      final payment = _payments.firstWhere(
        (p) => p.boarderId == boarderId && p.month == month && p.year == year,
      );
      if (payment.isPaid) {
        return 0;
      }
    } catch (e) {
      // Payment not found
    }

    try {
      final boarder = _boarders.firstWhere(
        (b) => b.key == boarderId,
      );
      balance = boarder.monthlyRent;
    } catch (e) {
      // Boarder not found
    }

    final boarderFees = _fees
      .where((f) => f.boarderId == boarderId && 
                    f.feeDate.month == month && 
                    f.feeDate.year == year)
      .fold(0.0, (sum, f) => sum + f.amount);

    balance += boarderFees;
    return balance;
  }
}
