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

class BudgetObject extends FinanceObject<BudgetStat> with TransactionHistory {
  double allocatedAmount;
  double currentBalance;

  // static const Map<BudgetStat, String> preDefinedStats = {
  //   BudgetStat.allocated: 'Allocated',
  //   BudgetStat.remaining: 'Remaining',
  //   BudgetStat.spent: 'Spent'
  // };

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    BudgetStat stat1,
    BudgetStat stat2,
  }) : super(FinanceObjectType.budget, name: title) {
    this.currentBalance = this.allocatedAmount;
    this.stat_1 = stat1;
    this.stat_2 = stat2;
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
        // TODO: Handle this case.
        break;
      case BudgetStat.remaining:
        // TODO: Handle this case.
        break;
      case BudgetStat.spent:
        // TODO: Handle this case.
        break;
    }
  }
}
