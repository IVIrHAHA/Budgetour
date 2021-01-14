import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

class CashOnHand with CashHandler, TransactionHistory {
  /// Making of a singleton
  static final CashOnHand _instance = CashOnHand._internal();

  factory CashOnHand() {
    return _instance;
  }

  CashOnHand._internal() {
    // TODO: Load CashOnHand
  }

  static CashOnHand get instance => _instance;

} 
