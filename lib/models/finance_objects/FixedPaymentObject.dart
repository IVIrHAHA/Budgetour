import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/routes/FixedPaymentObj_route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FixedPaymentFrequency {
  monthly,
  weekly,
  bi_monthly,
}

enum FixedPaymentStats {
  monthlyPayment,
  pending,
  nextDue,
  supplied,
}

class FixedPaymentObject extends FinanceObject<FixedPaymentStats>
    with TransactionHistory {
  final double fixedPayment;
  double _amountPaid;
  FixedPaymentFrequency frequency;

  /// when the next due date is coming
  DateTime nextDueDate;

  /// Determine dueDate reference
  DateTime _lastDueDate; // If nothing entered for nextDueDate, use date created

  FixedPaymentObject({
    @required String name,
    @required this.fixedPayment,
    this.frequency = FixedPaymentFrequency.monthly,
    this.nextDueDate,
  }) : super(name: name) {
    this._lastDueDate = this.nextDueDate ?? DateTime.now();
    this._amountPaid = 0.0;
  }

  get lastDueDate => _lastDueDate;

  setDueDate(DateTime dueDate) {
    this.nextDueDate = dueDate;
    this._lastDueDate = dueDate;
  }

  DateTime _setNextDueDate() {
    switch (frequency) {
      case FixedPaymentFrequency.monthly:
        nextDueDate = _lastDueDate.add(Duration(days: 30)); // TODO: Revise
        break;
      case FixedPaymentFrequency.weekly:
        nextDueDate = _lastDueDate.add(Duration(days: 7));
        break;
      case FixedPaymentFrequency.bi_monthly:
        return _lastDueDate;
        break;
    }
    return nextDueDate;
  }

  get pending => fixedPayment - _amountPaid;

  isPaid() => _amountPaid == fixedPayment;

  @override
  Widget getLandingPage() {
    return FixedPaymentObjRoute(this);
  }

  @override
  Color getTileColor() {
    return this.isPaid()
        ? ColorGenerator.fromHex(GColors.positiveColor)
        : ColorGenerator.fromHex(GColors.neutralColor);
  }

  @override
  QuickStat determineStat(statType) {
    switch (statType) {
      case FixedPaymentStats.monthlyPayment:
        return QuickStat(title: 'Payment Amount', value: fixedPayment);
        break;
      case FixedPaymentStats.nextDue:
        return QuickStat(
          title: 'Due',
          evaluateValue: Future<String>(() {
            return DateFormat('M/d').format(_setNextDueDate());
          }),
        );
        break;
      case FixedPaymentStats.pending:
        return QuickStat(
          title: 'Pending',
          evaluateValue: Future(
            () {
              return Format.formatDouble(pending, 2);
            },
          ),
        );
        break;
      case FixedPaymentStats.supplied:
        return QuickStat(title: 'Supplied', value: cashReserve);
        break;
    }
  }

  @override
  Transaction spendCash(double amount) {
    /// Update paidAmount
    _amountPaid += amount;
    print('amount paid: $_amountPaid');
    return super.spendCash(amount);
  }

  @override
  void transferReciept(Transaction transferReciept, CashHandler from) {
    if(this.pending == transferReciept.amount) {
      affirmation = 'This bill is ready to pay';
    }
  }

  @override
  bool acceptTransfer(double amount) {
    /// Only accept if amount to transfer plus the amount already passed and paid is less
    /// than the fixedPayment minus the amount already contributed and not paid.
    if ((amount + _amountPaid) <= (fixedPayment - cashReserve)) {
      return true;
    } else
      return false;
  }

  @override
  double transferRequest() {
    return pending;
  }
}
