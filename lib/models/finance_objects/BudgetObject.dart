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

import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

import 'Transaction.dart';

class QuickStatBundle<FinanceObject> {
  final String request1;
  final String request2;

  QuickStat _quickStat1;
  QuickStat _quickStat2;

  final FinanceObject aObj;

  QuickStatBundle(this.aObj, {this.request1, this.request2}) {
    /// Create [QuickStatBundle] for a [BudgetObject]
    if (this.aObj is BudgetObject) {
      if (request1 != null)
        this._quickStat1 = _budgetQuickStat((aObj as BudgetObject), request1);

      if (request2 != null)
        this._quickStat2 = _budgetQuickStat((aObj as BudgetObject), request2);
    }
  }

  _budgetQuickStat(BudgetObject obj, String request) {
    /// Derive [BudgetQuickStat] from request
    /// ** Make it easier to determine what you are trying to create
    BudgetQuickStat stat = BudgetObject.preDefinedStats.keys.firstWhere(
        (element) => BudgetObject.preDefinedStats[element] == request);

    switch (stat) {
      case BudgetQuickStat.allo:
        return QuickStat(title: request, value: obj.allocatedAmount);
        break;
      case BudgetQuickStat.rem:
        // TODO: Handle this case.
        break;
      case BudgetQuickStat.spent:
        return QuickStat(
            title: request,
            evaluateValue: Future<double>(obj.getMonthlyExpenses));
        break;
    }
  }

  QuickStat get stat1 => _quickStat1;
  QuickStat get stat2 => _quickStat2;
}

class QuickStat {
  final String title;
  final double value;

  final Future evaluateValue;

  QuickStat({this.title, this.value, this.evaluateValue});
}

enum BudgetQuickStat {
  allo,
  rem,
  spent,
}

class BudgetObject extends FinanceObject with TransactionHistory {
  double allocatedAmount;
  double currentBalance;
  static const Map<BudgetQuickStat, String> preDefinedStats = {
    BudgetQuickStat.allo: 'Allocated',
    BudgetQuickStat.rem: 'Remaining',
    BudgetQuickStat.spent: 'Spent'
  };

  BudgetObject({
    @required String title,
    this.allocatedAmount = 0,
    BudgetQuickStat stat1,
    BudgetQuickStat stat2,
  }) : super(FinanceObjectType.budget, name: title) {
    this.currentBalance = this.allocatedAmount;

    setQuickStatBundle(QuickStatBundle(
      this,
      request1: preDefinedStats[stat1],
      request2: preDefinedStats[stat2],
    ));
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

  getQuickBundle() {}
}
