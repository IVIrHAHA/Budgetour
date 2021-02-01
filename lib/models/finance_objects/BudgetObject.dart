/*
 *  Dictates BudgetObject behaviour.
 *  
 *  Basic Idea:
 *    1. Have an allocated amount which replenishes after a period time, 
 *    usually a month.
 * 
 *    2. Track how much user has spent/not spent.
 */

import 'dart:convert';

import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import '../BudgetourReserve.dart';
import 'FinanceObject.dart';
import '../interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

enum BudgetStat {
  allocated,
  remaining,
  spent,
}

/// TODO: CONTEMPLATE RENAMING THIS AS DynamicPaymentObject
class BudgetObject extends FinanceObject<BudgetStat>
    with TransactionHistory, Recurrence {
  BudgetObject({
    @required String title,
    @required CategoryType categoryType,
    this.targetAlloctionAmount = 0,
    BudgetStat stat1,
    BudgetStat stat2,
    DateTime startingDate,
    var definedOccurence,
  }) : super(
          name: title,
          categoryIndex: CategoryType.values.indexOf(categoryType),
        ) {
    this.startingDate = startingDate ?? DateTime.now();
    this.recurrence = definedOccurence ?? DefinedOccurence.monthly;

    this.firstStat = stat1;
    this.secondStat = stat2;
  }

  double targetAlloctionAmount;

  /// Gets set during auditing process
  bool _overBudget = false;

  /// True when auditing a transaction [_auditTransaction]
  /// False when Transfer completes [transferReciept]
  bool _thisRequested = false;

  /// Things BudgetObject needs to communicate to user
  /// 1. User is overbudget
  /// 2. User needs to refill budget
  /// 3. (Optional for now) Budget is almost out
  ///   3a. Budget is almost out and still has a lot of time left
  /// 4. User went over targeted budget

  /// Does not logTransaction, in case user wants to add a note
  /// of their own.
  @override
  Transaction spendCash(double amount) {
    Transaction cashTransaction = super.spendCash(amount);

    if (cashTransaction == null) {
      print('auditing');
      cashTransaction = _auditTransaction(cashTransaction, amount);
    }

    return cashTransaction;
  }

  /// Determines if the transaction will cause this budget to go over.
  /// If so, then tries to pull unallocated funds to process transaction
  ///
  /// Post-Case A: Transaction is processed by using any remaining funds in
  ///              in this budget and pulls the rest from unallocated resources.
  ///
  /// Post-Case B: This [BudgetObject] freezes and the Transaction is unable to process.
  ///              As a result, user must manually unallocate resources from other
  ///              [FinanceObject]s. At which point, this [BudgetObject] will try again
  ///              to process the Transaction.
  Transaction _auditTransaction(Transaction fromSuper, double amount) {
    // Try and get unallocated resources to cover this transaction
    try {
      _overBudget = true;
      _thisRequested = true;
      // Calculate missing funds
      var amountNeeded = amount - cashReserve;
      // This will throw exception if not successful
      CashOnHand.instance.transferToHolder(this, amountNeeded);

      // Transfer was successful
      // Re-do Transaction
      return super.spendCash(amount);
    }
    // Transfer was unsuccessful, cannot spend cash
    catch (Exception) {
      /// TODO: FREEZE THIS AND HOLD THE TRANSACTION
      /// UNIL USER FINDS RESOURCES OR DELETES THIS TRANSACTION
      throw Exception('TODO: FREEZE THIS: $name');
    }
  }

  @override
  void transferReciept(Transaction transferReciept, CashHandler from) {
    /// [this] did not request the transfer, rather an external object initiated the
    /// transfer
    if (!_thisRequested) {
      transferReciept.description = 'refill';

      if (isDue && cashReserve >= targetAlloctionAmount) {
        _reset();
      }
    }

    /// Only enters when auditing a transaction.
    /// Mark transaction as 'went overbudget'.
    else if (_thisRequested) {
      transferReciept.description = 'went overbudget';
      transferReciept.perceptibleColor =
          ColorGenerator.fromHex(GColors.blueish);
      _thisRequested = false;
    }
  }

  /* ----------------------------------------------------------------------------
   *  Tile Formating and misc methods
   * --------------------------------------------------------------------------*/
  @override
  bool acceptTransfer(double transferAmount) {
    return true;
  }

  @override
  double suggestedTransferAmount() {
    return this.targetAlloctionAmount - this.cashReserve;
  }

  @override
  Text getAffirmation() {
    switch (_getStatus()) {
      case _BudgetStatus.onTrack:
        return _buildText('');
        break;

      case _BudgetStatus.over_NotRefilled_NotDue:
        return _buildText('over budget, out of funds', color: Colors.red);
        break;

      case _BudgetStatus.over_Refilled_NotDue:
        return _buildText('over targeted amount', color: Colors.grey);
        break;

      case _BudgetStatus.needsRefill:
        return _buildText('needs refill', color: Colors.red);
        break;

      case _BudgetStatus.roll_over:
        return _buildText('');
        break;

      case _BudgetStatus.spentExactAmount:
        return _buildText('out of funds, consider refill', color: Colors.grey);
        break;
    }
    return _buildText('');
  }

  int amount = 1;
  _reset() {
    amount++;
    _overBudget = false;
    notifyDates();
  }

  _buildText(String text, {Color color = Colors.black}) {
    return Text(text, style: TextStyle(color: color));
  }

  /// Tile Color will display red when user has gone over budget
  /// Otherwise, keep as neutral color
  @override
  Color getTileColor() {
    switch (_getStatus()) {
      case _BudgetStatus.onTrack:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _BudgetStatus.over_NotRefilled_NotDue:
        return ColorGenerator.fromHex(GColors.alertColor);
        break;

      case _BudgetStatus.over_Refilled_NotDue:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _BudgetStatus.needsRefill:
        return ColorGenerator.fromHex(GColors.warningColor);
        break;

      case _BudgetStatus.spentExactAmount:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _BudgetStatus.roll_over:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;
    }
    return ColorGenerator.fromHex(GColors.neutralColor);
  }

  /// Lists possible outcomes after dealing with a [BudgetObject]
  _BudgetStatus _getStatus() {
    // On track, thus far
    if (!_overBudget && cashReserve > 0 && !isDue) {
      return _BudgetStatus.onTrack;
    }
    // Currently overbudget and has not refilled funds
    else if (_overBudget && cashReserve == 0 && !isDue) {
      return _BudgetStatus.over_NotRefilled_NotDue;
    }
    // User has gone over targeted budget, but refilled
    else if (_overBudget && cashReserve > 0 && !isDue) {
      return _BudgetStatus.over_Refilled_NotDue;
    }
    // Time to refill and reset
    else if (isDue && cashReserve < targetAlloctionAmount) {
      return _BudgetStatus.needsRefill;
    }
    // BudgetObject already financed, roll-over to next period
    else if (isDue && cashReserve >= targetAlloctionAmount) {
      _reset();
      return _BudgetStatus.roll_over;
    }
    // Spent exact amount
    else if (!isDue && cashReserve == 0) {
      return _BudgetStatus.spentExactAmount;
    } else {
      throw Exception('Unexpected circumstance');
    }
  }

  @override
  Widget getLandingPage() {
    return BudgetObjRoute(this);
  }

  @override
  QuickStat determineStat(BudgetStat statType) {
    switch (statType) {
      case BudgetStat.allocated:
        return QuickStat(
            title: 'Target Allocation', value: targetAlloctionAmount);
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

  /* --------------------------------------------------------------------------------------------
   *  PERSISTENCE METHODS
   * --------------------------------------------------------------------------------------------
   */

  static const String _nameColumn = 'name';
  static const String _categoryColumn = 'categoryId';
  static const String _allocationColumn = 'allocation';
  static const String _sDateColumn = 'starting_date';
  static const String _defOccurenceColumn = 'definedOccurence';
  static const String _stat1Column = 'stat1';
  static const String _stat2Column = 'stat2';
  static const String _overBudgetColumn = 'budgetStatus';

  @override
  double get transactionLink => this.id;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      _nameColumn: this.name,
      _categoryColumn: this.categoryIndex,
      _allocationColumn: this.targetAlloctionAmount,
      _sDateColumn: this.startingDate.millisecondsSinceEpoch,
      _defOccurenceColumn: getOccurenceJson(),
      _stat1Column: this.firstStat.toString(),
      _stat2Column: this.secondStat.toString(),
      _overBudgetColumn: this._overBudget ? 1 : 0,
    };
    return jsonMap;
  }

  BudgetObject.fromJson(Map map)
      : super(name: map[_nameColumn], categoryIndex: map[_categoryColumn]) {
    this.targetAlloctionAmount = map[_allocationColumn];
    this.firstStat = statEnumFromString(BudgetStat.values, map[_stat1Column]);
    this.secondStat = statEnumFromString(BudgetStat.values, map[_stat2Column]);
    this.startingDate = DateTime.fromMillisecondsSinceEpoch(map[_sDateColumn]);
    this.recurrence = occurenceEnumFromString(map[_defOccurenceColumn]);
    this._overBudget = map[_overBudgetColumn] == 1 ? true : false;
  }
}

enum _BudgetStatus {
  onTrack,
  over_NotRefilled_NotDue,
  over_Refilled_NotDue,
  needsRefill,
  roll_over,
  spentExactAmount,
}
