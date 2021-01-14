import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

class CashOnHand with TransactionHistory {
  /// Making of a singleton
  static final CashOnHand _instance = CashOnHand._internal();

  factory CashOnHand() {
    return _instance;
  }

  CashOnHand._internal() {
    // TODO: Load liquidAmount
    _amount = 0;
  }

  static CashOnHand get instance => _instance;

  double _amount;

  double get amount => _amount;

  @override
  logTransaction(Transaction transaction) {

  }
}
