import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';

import 'finance_objects/BudgetObject.dart';

/// The 5 Categories of the program
enum CategoryType {
  essential,
  security,
  goals,
  lifestyle,
  miscellaneous,
}

/// Singleton class which manages the 5 Category lists of the
/// program.
///
/// 1. Essentials
///   [CategoryType.essential]
///
/// 2. Security
///   [CategoryType.security]
///
/// 3. Goals
///   [CategoryType.goals]
///
/// 4. Lifestyle
///   [CategoryType.lifestyle]
///
/// 5. Miscellaneous
///   [CategoryType.miscellaneous]

class CategoryListManager extends _CategoryListBase {
  /// This and only instance of [CategoryListManager]
  static final CategoryListManager _instance = CategoryListManager._internal();

  factory CategoryListManager() {
    return _instance;
  }

  // Initialize the category lists
  CategoryListManager._internal() {
    _essentialList = InitTestData.dummyEssentialList;
    _securityList = InitTestData.dummySecurityList;
    _goalList = InitTestData.dummyGoalList;
    _lifeStyleList = InitTestData.dummyLifeStyleList;
    _miscList = InitTestData.dummyMiscList;
  }

  /// Get this [_instance]
  static CategoryListManager get instance => _instance;

  /// Adds [FinanceObject] to specified Category list using [CategoryType]
  add(FinanceObject what, CategoryType where) {
    switch (where) {
      case CategoryType.essential:
        _essentialList.add(what);
        break;

      case CategoryType.security:
        _securityList.add(what);
        break;

      case CategoryType.goals:
        _goalList.add(what);
        break;

      case CategoryType.lifestyle:
        _lifeStyleList.add(what);
        break;

      case CategoryType.miscellaneous:
        _miscList.add(what);
        break;
    }
  }
}

/// The 5 Category lists.
///
/// ** Seperated as to not make the singlton class above
/// overly complicated.

abstract class _CategoryListBase {
  List<FinanceObject> _essentialList,
      _securityList,
      _goalList,
      _lifeStyleList,
      _miscList;

  get essentials => _essentialList;

  get securities => _securityList;

  get goals => _goalList;

  get lifestyle => _lifeStyleList;

  get misc => _miscList;
}

class CategoryListAnalyzer {
  /// Calculates the alloted amounts in the following [FinanceObject] types
  /// - [BudgetObject]
  /// - [FixedPaymentObject]
  static double getAllocatedAmount(List<FinanceObject> list) {
    double amount = 0;

    for (FinanceObject obj in list) {
      if (obj is BudgetObject) {
        amount += obj.targetAlloctionAmount;
      } else if (obj is FixedPaymentObject) {
        amount += obj.fixedPayment;
      }
    }

    return amount;
  }

  /// Calculates the unspent amounts in the following [FinanceObject] types
  /// - [BudgetObject]
  /// - [FixedPaymentObject]
  static double getUnspentAmount(List<FinanceObject> list) {
    double unspent = 0;

    for (FinanceObject obj in list) {
      if (obj is BudgetObject) {
        unspent += obj.cashReserve;
      } else if (obj is FixedPaymentObject) {
        if (!obj.isPaid()) unspent += obj.fixedPayment;
      }
    }

    return unspent;
  }
}
