import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/routes/FixedPaymentObj_route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

enum FixedPaymentFrequency {
  monthly,
  weekly,
  bi_monthly,
}

enum FixedPaymentStats {
  monthlyPayment,
  nextDue,
}

class FixedPaymentObject extends FinanceObject<FixedPaymentStats>
    with TransactionHistory {
  final double monthlyFixedPayment;
  double paymentAmount;
  FixedPaymentFrequency frequency;

  /// when the next due date is coming
  DateTime nextDueDate;

  /// Determine dueDate reference
  DateTime _lastDueDate; // If nothing entered for nextDueDate, use date created

  FixedPaymentObject({
    @required String name,
    @required this.monthlyFixedPayment,
    this.frequency = FixedPaymentFrequency.monthly,
    this.nextDueDate,
  }) : super(FinanceObjectType.fixed, name: name) {
    this._lastDueDate = nextDueDate ?? DateTime.now();
    this.paymentAmount = 0;
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
        // TODO: Handle this case.
        break;
      case FixedPaymentFrequency.bi_monthly:
        // TODO: Handle this case.
        break;
    }
  }

  isPaid() => paymentAmount == monthlyFixedPayment ? true : false;

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
        return QuickStat(title: 'Payment Amount', value: monthlyFixedPayment);
        break;
      case FixedPaymentStats.nextDue:
        return QuickStat(title: 'Payment Amount', value: monthlyFixedPayment);
        break;
    }
  }
}
