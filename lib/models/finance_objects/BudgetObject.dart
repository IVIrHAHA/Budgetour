/*
 *  Dictates BudgetObject behaviour.
 *  
 *  Basic Idea:
 *    1. Have an allocated amount which replenishes after a period time, 
 *    usually a month.
 * 
 *    2. Track how much user has spent/not spent.
 */

import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';

import '../StatManager.dart';
import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

import 'Transaction.dart';

enum BudgetStat {
  allocated,
  remaining,
  spent,
}

class BudgetObject extends FinanceObject<BudgetStat> with TransactionHistory {
  double allocatedAmount;
  double currentBalance;

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    BudgetStat stat1,
    BudgetStat stat2,
  }) : super(FinanceObjectType.budget, name: title) {
    this.currentBalance = this.allocatedAmount;
    this.firstStat = stat1;
    this.secondStat = stat2;
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

  @override
  QuickStat determineStat(BudgetStat statType) {
    switch (statType) {
      case BudgetStat.allocated:
        return QuickStat(title: 'Allocated', value: allocatedAmount);
        break;
      case BudgetStat.remaining:
        return QuickStat(
          title: 'Remaining',
          evaluateValue: Future(() {
            return allocatedAmount - this.getMonthlyExpenses();
          }),
        );
        break;
      case BudgetStat.spent:
        return QuickStat(
            title: 'Spent', evaluateValue: Future(this.getMonthlyExpenses));
        break;
    }
    return null;
  }
}
