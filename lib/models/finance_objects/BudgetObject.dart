/*
 *  Dictates BudgetObject behaviour.
 *  
 *  Basic Idea:
 *    1. Have an allocated amount which replenishes after a period time, 
 *    usually a month.
 * 
 *    2. Track how much user has spent/not spent.
 */

import 'package:budgetour/models/finance_objects/LabelObject.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';

import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

import 'Transaction.dart';

class BudgetObject extends FinanceObject with TransactionHistory {
  double allocatedAmount;
  double currentBalance;

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    LabelObject label1,
    LabelObject label2,
  }) : super(FinanceObjectType.budget,
            name: title, label_1: label1, label_2: label2) {
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

  @override
  Widget getLandingPage() {
    return BudgetObjRoute(this);
  }

  @override
  Color getTileColor() {
    if (this.isOverbudget()) {
      return ColorGenerator.fromHex(GColors.warningColor);
    } else
      return ColorGenerator.fromHex(GColors.neutralColor);
  }

  static LabelObject get allocationAmount => PreDefinedLabels.allocationAmount;
}
