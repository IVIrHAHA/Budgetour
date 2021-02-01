import 'package:budgetour/models/BudgetourReserve.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/tools/DatabaseProvider.dart';
import 'package:budgetour/tools/GlobalValues.dart';

import 'FinanceObject.dart';

class CashOnHand with CashHandler, TransactionHistory {
  /// Making of a singleton
  static final CashOnHand _instance = CashOnHand._internal();

  factory CashOnHand() {
    return _instance;
  }

  CashOnHand._internal() {

  }

  static const String _idName = 'com.bugetour.CashOnHand';
  static CashOnHand get instance => _instance;

  /// Produces a [Transaction] object with an automated 'Deposited' description.
  /// However, does not log the transaction.
  @override
  Future<Transaction> reportIncome(double amount) async {
    return await super.reportIncome(amount).then((report) {
      report.description = 'Deposited';
      return report;
    });
  }

  /// Auto Logs the amount deposited and gives [Transaction.description] the
  /// String value 'Deposited'
  void autoLogDeposit(double amount) {
    this.reportIncome(amount);
  }

  @override
  Future<Transaction> transferReciept(
      Future<Transaction> transferReciept, CashHolder to) {
    return transferReciept.then((value) {
      value.description = 'refilled ${(to as FinanceObject).name}';
      return value;
    });
  }

  @override
  bool agreeToTransfer(double amount) {
    if (amount <= this.cashAmount) {
      return true;
    } else {
      return false;
    }
  }

  @override
  double get transactionLink => _idName.hashCode.toDouble();

  @override
  Map<String, dynamic> toMap() {
    return {
      DbNames.ch_TransactionLink: transactionLink,
      DbNames.ch_CashReserve: cashAmount,
    };
  }
}
