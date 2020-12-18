import 'package:budgetour/objects/FinanceObject.dart';
import 'package:flutter/material.dart';

class BudgetObject extends FinanceObject {
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

  logTransaction(double amount) {
    currentBalance = currentBalance - amount;
  }

  isOverbudget() {
    return currentBalance < 0 ? true : false;
  }
}
