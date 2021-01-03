import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/routes/GoalObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class GoalObject extends FinanceObject {
  double targetAmount;
  double totalContribution;

  // Contributing method
  // Complete by date
  DateTime completeByDate;

  // Complete by fixed payments
  double contributeByFixedAmount;

  /// ```
  /// Duration frequency;
  /// ```
  /// Default to monthly for now. May at somepoint implement
  /// other time frames

  // Complete by percentage
  double contributeByPercent;

  GoalObject(
    this.targetAmount, {
    @required String name,
    this.completeByDate,
    this.contributeByFixedAmount,
    this.contributeByPercent,
    this.totalContribution = 0,
  }) : super(FinanceObjectType.goal, name: name);

  contribute(double contributionAmount) {
    totalContribution += contributionAmount;
  }

  isReady() {
    return targetAmount <= totalContribution;
  }

  /// Set as methods
  setAsFixedAmountContribution(double amount) {
    contributeByFixedAmount = amount;
    contributeByPercent = null;
    completeByDate = null;
  }

  setAsPercentageContribution(double percentage) {
    contributeByFixedAmount = null;
    contributeByPercent = percentage;
    completeByDate = null;
  }

  setAsCompleteByDate(DateTime dueDate) {
    contributeByFixedAmount = null;
    contributeByPercent = null;
    completeByDate = dueDate;
  }

  @override
  Widget getLandingPage() {
    return GoalObjRoute(this);
  }

  @override
  Color getTileColor() {
    if (this.isReady()) {
      return ColorGenerator.fromHex(GColors.positiveColor);
    } else
      return ColorGenerator.fromHex(GColors.neutralColor);
  }
}