import 'dart:math';

import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';

import 'models/CashManager.dart';
import 'models/finance_objects/BudgetObject.dart';
import 'models/finance_objects/FinanceObject.dart';
import 'models/finance_objects/GoalObject.dart';

class InitTestData {
  static final List<FinanceObject> dummyEssentialList = List<FinanceObject>();
  static final List<FinanceObject> dummySecurityList = List<FinanceObject>();
  static final List<FinanceObject> dummyGoalList = List<FinanceObject>();
  static final List<FinanceObject> dummyLifeStyleList = List<FinanceObject>();
  static final List<FinanceObject> dummyMiscList = List<FinanceObject>();

  static void initTileList() {
    buildEssentialList();
    buildSecurityList();
    buildGoalList();
    buildLifeStyleList();
    buildMiscList();
  }

  static buildEssentialList() {
    dummyEssentialList.add(_buildBudgetObjects('Food', 150, transactionQTY: 0));
    dummyEssentialList.add(_buildBudgetObjects('Gas', 135, transactionQTY: 4));
    dummyEssentialList
        .add(_buildBudgetObjects('House Bills', 120, transactionQTY: 0));
    dummyEssentialList
        .add(_buildFixedPaymentObject('Rent', 578, DateTime(2021, 1, 1)));
    dummyEssentialList.add(
        _buildFixedPaymentObject('Car Insurance', 42, DateTime(2021, 1, 8)));
  }

  static buildSecurityList() {
    dummySecurityList
        .add(_buildFixedPaymentObject('Fidelity', 200, DateTime(2021, 1, 14)));
  }

  static buildGoalList() {}

  static buildLifeStyleList() {
    dummyLifeStyleList
        .add(_buildFixedPaymentObject('Spotify', 9.99, DateTime(2021, 1, 21)));
    dummyLifeStyleList
        .add(_buildFixedPaymentObject('Quip', 5.41, DateTime(2021, 1, 26)));
    dummyLifeStyleList.add(
        _buildFixedPaymentObject('Nuero Gum', 20.27, DateTime(2021, 1, 3)));
  }

  static buildMiscList() {}

  static BudgetObject _buildBudgetObjects(String title, double allocationAmount,
      {int transactionQTY}) {
    BudgetObject obj;
    // Explicitly target an Object
    if (title == 'Food') {
      obj = BudgetObject(
        title: title,
        targetAlloctionAmount: allocationAmount,
        stat1: BudgetStat.spent,
        stat2: BudgetStat.remaining,
      );
      CashOnHand.instance.transferToHolder(obj, 150);
    }

    /// Build BudgetObject
    else {
      obj = BudgetObject(
        title: title,
        targetAlloctionAmount: allocationAmount,
        stat1: BudgetStat.allocated,
        stat2: BudgetStat.spent,
      );
      CashOnHand.instance.transferToHolder(obj, 100);
    }

    // Spend random amounts
    for (int i = 0; i < transactionQTY; i++) {
      Transaction reciept = obj.spendCash(_doubleInRange(5, 25));

      if (reciept != null) {
        reciept.date = DateTime.now().subtract(Duration(days: i * 3));
        obj.logTransaction(reciept..description = 'auto gen trans${i + 1}');
      } else {
        print('trans did not register: ${obj.name} - trans${i + 1}');
      }
    }

    return obj;
  }

  // Eventually have history, labels and due dates
  static FixedPaymentObject _buildFixedPaymentObject(
      String title, double amount, DateTime lastDue) {
    FixedPaymentObject obj = FixedPaymentObject(
      name: title,
      fixedPayment: amount,
      definedOccurence: DefinedOccurence.monthly,
      lastDueDate: lastDue,
    );

    if(obj.name == 'Fidelity')
      obj.markAsAutoPay = true;

    obj.firstStat = FixedPaymentStats.supplied;
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
