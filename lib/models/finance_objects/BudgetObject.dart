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
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import '../CashManager.dart';
import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

enum BudgetStat {
  allocated,
  remaining,
  spent,
}

class BudgetObject extends FinanceObject<BudgetStat>
    with TransactionHistory, Recurrence {
  double targetAlloctionAmount;

  BudgetObject({
    @required String title,
    this.targetAlloctionAmount = 0,
    BudgetStat stat1,
    BudgetStat stat2,
  }) : super(
          name: title,
        ) {
    this.firstStat = stat1;
    this.secondStat = stat2;
  }

  /// Things BudgetObject needs to communicate to user
  /// 1. User is overbudget
  /// 2. User needs to refill budget
  /// 3. (Optional for now) Budget is almost out
  ///   3a. Budget is almost out and still has a lot of time left
  /// 4. User went targeted budget

  setAffirmation() {
    // Currently overbudget
    if (_overBudget) {
      affirmation = 'Overbudget!';
      affirmationColor = Colors.red;
    }
    // User has gone over targeted budget, but refilled
    else if (this.getMonthlyStatement() > this.targetAlloctionAmount &&
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

  /// Does not logTransaction, in case user want to add a note
  /// of their own.
  @override
  Transaction spendCash(double amount) {
    Transaction cashTransaction = super.spendCash(amount);

    // User has gone overBudget
    if (cashTransaction == null) {
      // Try and get unallocated resources to cover this transaction
      try {
        _overBudget = true;
        _thisRequested = true;
        // Get missing funds
        var amountNeeded = amount - cashReserve;
        CashOnHand.instance.transferToHolder(this, amountNeeded);

        // Transfer was successful
        // Try and spend cash again
        cashTransaction = super.spendCash(amount);
      }
      // Transfer was unsuccessful, cannot spend cash
      catch (Exception) {
        _overBudget = false;
      }
    }
    setAffirmation();
    return cashTransaction;
  }

  /// Tile Color will display red when user has gone over budget
  /// Otherwise, keep as neutral color
  @override
  Color getTileColor() {
    if (_overBudget) {
      return ColorGenerator.fromHex(GColors.warningColor);
    } else
      return ColorGenerator.fromHex(GColors.neutralColor);
  }

  bool _overBudget = false;

  @override
  Widget getLandingPage() {
    return BudgetObjRoute(this);
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
              return Format.formatDouble(this.getMonthlyStatement(), 2);
            }));
        break;
    }
    return null;
  }

  /// The first of current month
  DateTime nextRefill = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
    0,
    0,
  );

  @override
  bool acceptTransfer(double transferAmount) {
    return true;
  }

  bool _thisRequested = false;

  @override
  void transferReciept(Transaction transferReciept, CashHandler from) {
    /// *BUG if user goes over budget and refills, and then refills again, it appears
    /// as though the user never violated the targeted alloted amount.
    ///
    /// [this] did not request the transfer, rather an external object initiated the
    /// transfer
    if (!_thisRequested) {
      transferReciept.description = 'refill';

      /// Went overbudget before alloted time frame
      if (_overBudget && !isDue) {
        affirmation = 'exceeded target budget';
        affirmationColor = Colors.grey;
        _overBudget = false;
      }

      /// Refilling on own accord
      else {
        setAffirmation();
        _overBudget = false;
      }
    }

    /// Should only enter when [this] had to pull missing funds.
    ///
    /// [this] initiated the transfer during [this.spendCash]
    /// Mark transaction as 'went overbudget'.
    else if (_overBudget && _thisRequested) {
      transferReciept.description = 'went overbudget';
      transferReciept.perceptibleColor =
          ColorGenerator.fromHex(GColors.blueish);
      _thisRequested = false;
    }

    logTransaction(transferReciept);
  }

  @override
  double suggestedTransferAmount() {
    return this.targetAlloctionAmount - this.cashReserve;
  }
}
