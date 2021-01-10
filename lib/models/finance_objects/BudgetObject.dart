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

class BudgetObject extends FinanceObject with TransactionHistory {
  double allocatedAmount;
  double currentBalance;

  final BudgetStat stat1, stat2;

  static const Map<BudgetStat, String> preDefinedStats = {
    BudgetStat.allocated: 'Allocated',
    BudgetStat.remaining: 'Remaining',
    BudgetStat.spent: 'Spent'
  };

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    this.stat1,
    this.stat2,
  }) : super(FinanceObjectType.budget, name: title) {
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

  @override
  get statBundle {
    return QuickStatBundle(
      this,
      request1: preDefinedStats[stat1],
      request2: preDefinedStats[stat2],
    );
  }
}
