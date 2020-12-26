import 'package:budgetour/objects/FinanceObject.dart';
import 'package:budgetour/objects/interfaces/TransactionMixin.dart';
import 'package:flutter/material.dart';

import 'Transaction.dart';

class BudgetObject extends FinanceObject with TransactionMixin {
  double allocatedAmount;
  double currentBalance;

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    String label1,
    String label2,
  }) : super(
          name: title,
          label_1: label1,
          label_2: label2,
        ) {
    this.currentBalance = this.allocatedAmount;
  }

  @override
  logTransaction(Transaction transaction) {
    if (transaction.date.month == DateTime.now().month) {
      currentBalance = currentBalance - transaction.amount;
    }
    super.logTransaction(transaction);
  }

  isOverbudget() {
    return currentBalance < 0 ? true : false;
  }
}
