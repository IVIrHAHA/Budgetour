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

class FixedPaymentObject extends FinanceObject with TransactionHistory {
  final double monthlyFixedPayment;
  double paymentAmount;
  FixedPaymentFrequency frequency;
  DateTime nextDueDate;
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

  DateTime _setNextDueDate() {}

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
}
