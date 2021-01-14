import 'dart:math';

import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:flutter/material.dart';

import 'models/CashManager.dart';
import 'models/Meta/Transaction.dart';
import 'models/finance_objects/BudgetObject.dart';
import 'models/finance_objects/FinanceObject.dart';
import 'models/finance_objects/GoalObject.dart';

class InitTestData {
  static final List<FinanceObject> dummyEssentialList = List<FinanceObject>();

  static initTileList() {
    dummyEssentialList
        .add(_buildBudgetObjects('Food', 150, transactionQTY: 10));
    dummyEssentialList.add(_buildBudgetObjects('Gas', 135, transactionQTY: 4));
    dummyEssentialList.add(_buildFixedPaymentObject('Rent', 578));

    return dummyEssentialList;
  }

  static BudgetObject _buildBudgetObjects(String title, double allocationAmount,
      {int transactionQTY}) {
    BudgetObject obj;
    // Create budget object
    if (title == 'Food') {
      obj = BudgetObject(
        title: title,
        targetAlloctionAmount: allocationAmount,
        stat1: BudgetStat.allocated,
        stat2: BudgetStat.remaining,
      );
      obj.logTransaction(
        Transaction(
          amount: 100,
          description: 'refill',
          date: DateTime(2021, 1, 1, 0, 0),
          perceptibleColor: Colors.green,
        ),
      );
    } else {
      obj = BudgetObject(
        title: title,
        targetAlloctionAmount: allocationAmount,
        stat1: BudgetStat.allocated,
        stat2: BudgetStat.spent,
      );
    }

    // Log random transactions
    for (int i = 0; i <= transactionQTY; i++) {
      obj.logTransaction(
        Transaction(
          description: 'Tran_${i + 1}',
          amount: _doubleInRange(5, 25) * -1,
          date: DateTime.now().subtract(Duration(days: i * 3)),
        ),
      );
    }

    return obj;
  }

  // Eventually have history, labels and due dates
  static FixedPaymentObject _buildFixedPaymentObject(
      String title, double amount) {
    FixedPaymentObject obj = FixedPaymentObject(
      name: title,
      monthlyFixedPayment: amount,
    );

    obj.firstStat = FixedPaymentStats.nextDue;
    obj.secondStat = FixedPaymentStats.nextDue;

    return obj;
  }

  static GoalObject _buildGoalObject(
    String name,
    double targetAmount, {
    double fixedAmount,
    double percentage,
    DateTime date,
  }) {
    if (fixedAmount != null) {
      return GoalObject(
        targetAmount,
        name: name,
        contributeByFixedAmount: fixedAmount,
      );
    } else if (percentage != null) {
      return GoalObject(
        targetAmount,
        name: name,
        contributeByPercent: percentage,
      );
    } else if (date != null) {
      return GoalObject(
        targetAmount,
        name: name,
        completeByDate: date,
      );
    }
  }

  static double _doubleInRange(num start, num end) =>
      Random().nextDouble() * (end - start) + start;
}
