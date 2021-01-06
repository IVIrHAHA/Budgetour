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
  double paymentAmount;
  FixedPaymentFrequency frequency;
  DateTime nextDueDate;
  DateTime _lastDueDate; // If nothing entered for nextDueDate, use date created

  FixedPaymentObject({
    @required String name,
    @required this.paymentAmount,
    this.frequency = FixedPaymentFrequency.monthly,
    this.nextDueDate,
    String label1,
    String label2,
  }) : super(FinanceObjectType.fixed,
            name: name, label_1: label1, label_2: label2) {
    this._lastDueDate = nextDueDate ?? DateTime.now();
  }

  get lastDueDate => _lastDueDate;

  setDueDate(DateTime dueDate) {
    this.nextDueDate = dueDate;
    this._lastDueDate = dueDate;
  }

  DateTime _setNextDueDate() {}

  isPaid() => paymentAmount == 0 ? true : false;

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
