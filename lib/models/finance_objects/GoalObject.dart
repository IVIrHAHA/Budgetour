import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:flutter/material.dart';

class GoalObject extends FinanceObject {
  double targetAmount;
  
  // Contributing method
  // Complete by date
  DateTime completeByDate;

  // Complete by fixed payments
  double contribeByAmount;

  /// ```
  /// Duration frequency;
  /// ```
  /// Default to monthly for now. May at somepoint implement
  /// other time frames

  // Contribute by percentage
  double contribeByPercent;


  GoalObject({@required String name}) : super(FinanceObjectType.goal, name:name);

  

}