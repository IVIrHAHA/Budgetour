import 'package:budgetour/objects/FinanceObject.dart';
import 'package:budgetour/objects/interfaces/TransactionMixin.dart';
import 'package:flutter/material.dart';

import 'Transaction.dart';

class BudgetObject extends FinanceObject with TransactionMixin {
  double allocatedAmount;
  double currentBalance;

  BudgetObject({
    @required String title,
    String label1,
    String label2,
    this.allocatedAmount = 0,
  }) : super(
          title: title,
          label_1: label1,
          label_2: label2,
        ) {
    this.currentBalance = this.allocatedAmount;
  }

  @override
  logTransaction(Transaction transaction) {
    currentBalance = currentBalance - transaction.amount;
    this.list.add(transaction);
  }

  isOverbudget() {
    return currentBalance < 0 ? true : false;
  }
}
