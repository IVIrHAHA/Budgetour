import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

import 'FinanceObject.dart';

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

  @override
  void transferReciept(Transaction transferReciept, CashHolder to) {
    transferReciept.description = 'refilled ${(to as FinanceObject).name}';
    logTransaction(transferReciept);
  }

  @override
  bool acceptTransfer(double amount) {
    if(amount <= this.cashAmount) {
      return true;
    }
    else {
      return false;
    }
  }

}
