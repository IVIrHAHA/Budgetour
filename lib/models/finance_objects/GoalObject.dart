import 'package:budgetour/models/finance_objects/FinanceObject.dart';
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
}
