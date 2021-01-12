import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

class CashObject with TransactionHistory {
  /// Making of a singleton
  static final CashObject _instance = CashObject._internal();

  factory CashObject() {
    return _instance;
  }

  CashObject._internal() {
    // TODO: Load liquidAmount
    liquidAmount = 0;
  }

  static CashObject get instance => _instance;

  double liquidAmount;

  @override
  logTransaction(Transaction transaction) { 
    liquidAmount += (transaction.amount * -1);
    super.logTransaction(transaction);
  }
}