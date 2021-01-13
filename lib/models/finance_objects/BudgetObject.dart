/*
 *  Dictates BudgetObject behaviour.
 *  
 *  Basic Idea:
 *    1. Have an allocated amount which replenishes after a period time, 
 *    usually a month.
 * 
 *    2. Track how much user has spent/not spent.
 */

import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

enum BudgetStat {
  allocated,
  remaining,
  spent,
}

class BudgetObject extends FinanceObject<BudgetStat> with TransactionHistory {
  double targetAlloctionAmount;

  BudgetObject({
    @required String title,
    this.targetAlloctionAmount = 0,
    double cashFeed = 0,
    BudgetStat stat1,
    BudgetStat stat2,
  }) : super(FinanceObjectType.budget, name: title, cashFeed: cashFeed) {
    this.firstStat = stat1;
    this.secondStat = stat2;
  }

  @override
  logTransaction(Transaction transaction) {
    /// If the transaction takes place during current month
    /// then update the financial state of this object
    /// ie. update cashReserve
    if (transaction.date.month == DateTime.now().month) {
      /// User has gone overbudget, log transaction with what is
      /// available in cashReserve and make an auto input transaction
      /// which tells the user they have overdrawn
      var overDrawn = this.withdraw(transaction.amount);
      if (overDrawn < 0) {
        transaction.amount = transaction.amount + overDrawn;
        super.logTransaction(transaction);

        transaction = Transaction(
            amount: -overDrawn,
            description: 'Overbudget! Replenish',
            perceptibleColor: ColorGenerator.fromHex(GColors.blueish));
      }
    }
    super.logTransaction(transaction);
    setAffirmation();
  }

  _isOverbudget() {
    return this.cashReserve < 0 ? true : false;
  }

  @override
  Widget getLandingPage() {
    return BudgetObjRoute(this);
  }

  @override
  Color getTileColor() {
    if (this._isOverbudget()) {
      return ColorGenerator.fromHex(GColors.warningColor);
    } else
      return ColorGenerator.fromHex(GColors.neutralColor);
  }

  @override
  QuickStat determineStat(BudgetStat statType) {
    switch (statType) {
      case BudgetStat.allocated:
        return QuickStat(title: 'Allocated', value: targetAlloctionAmount);
        break;
      case BudgetStat.remaining:
        return QuickStat(
          title: 'Remaining',
          value: cashReserve,
        );
        break;
      case BudgetStat.spent:
        return QuickStat(
            title: 'Spent',
            evaluateValue: Future(() {
              return Format.formatDouble(this.getMonthlyExpenses(), 2);
            }));
        break;
    }
    return null;
  }

  setAffirmation() {
    // Currently overbudget
    if (cashReserve < 0) {
      affirmation = 'Overbudget!';
      affirmationColor = Colors.red;
    } 
    // User has gone over targeted budget, but refilled
    else if (this.getMonthlyExpenses() > this.targetAlloctionAmount &&
        cashReserve > 0) {
      affirmation = 'exceeded allocation target';
      affirmationColor = ColorGenerator.fromHex(GColors.borderColor);
    } 
    // User is on track thus far
    else {
      affirmation = '';
      affirmationColor = null;
    }
  }
}
