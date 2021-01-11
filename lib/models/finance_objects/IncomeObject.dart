import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

class IncomeObject with TransactionHistory {
  /// Making of a singleton
  static final IncomeObject _instance = IncomeObject._internal();

  factory IncomeObject() {
    return _instance;
  }

  IncomeObject._internal() {
    // TODO: Load liquidAmount
    liquidAmount = 0;
  }

  static IncomeObject get instance => _instance;

  double liquidAmount;
}