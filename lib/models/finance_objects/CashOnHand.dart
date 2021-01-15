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

  /// Produces a [Transaction] object with an automated 'Deposited' description.
  /// However, does not log the transaction.
  @override
  reportIncome(double amount) {
    Transaction report = super.reportIncome(amount);
    report.description = 'Deposited';
    return report;
  }

  /// Auto Logs the amount deposited and gives [Transaction.description] the 
  /// String value 'Deposited'
  void autoLogDeposit(double amount) {
    Transaction report = this.reportIncome(amount);
    logTransaction(report);
  }

  static CashOnHand get instance => _instance;

}
