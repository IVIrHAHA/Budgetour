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
  }) : super(name: name) {
    this._lastDueDate = this.nextDueDate ?? DateTime.now();
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
        nextDueDate = _lastDueDate.add(Duration(days: 7));
        break;
      case FixedPaymentFrequency.bi_monthly:
        return _lastDueDate;
        break;
    }
    return nextDueDate;
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
        return QuickStat(
          title: 'Due',
          evaluateValue: Future<String>(() {
            return DateFormat('M/d').format(_setNextDueDate());
          }),
        );
        break;
      case FixedPaymentStats.pending:
        return QuickStat(
          title: 'pending',
          evaluateValue: Future(
            () {
              var pendingAmount = monthlyFixedPayment - paymentAmount;
              return Format.formatDouble(pendingAmount, 2);
            },
          ),
        );
        break;
    }
  }
}
