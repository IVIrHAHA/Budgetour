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
    // _essentialList = InitTestData.dummyEssentialList;
    // _securityList = InitTestData.dummySecurityList;
    // _goalList = InitTestData.dummyGoalList;
    // _lifeStyleList = InitTestData.dummyLifeStyleList;
    // _miscList = InitTestData.dummyMiscList;
  }

  /// Get this [_instance]
  static CategoryListManager get instance => _instance;

  /// Adds [FinanceObject] to specified Category list using [CategoryType]
  add(FinanceObject what, CategoryType where) {
    switch (where) {
      case CategoryType.essential:
        if(!_essentialList.any((element) => element.id == what .id))
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

  remove(FinanceObject what, CategoryType where) {
    switch (where) {
      case CategoryType.essential:
        _essentialList.removeWhere((element) => element.id == what.id);
        break;
      case CategoryType.security:
        _securityList.removeWhere((element) => element.id == what.id);
        break;
      case CategoryType.goals:
        _goalList.removeWhere((element) => element.id == what.id);
        break;
      case CategoryType.lifestyle:
        _lifeStyleList.removeWhere((element) => element.id == what.id);
        break;
      case CategoryType.miscellaneous:
        _miscList.removeWhere((element) => element.id == what.id);
        break;
    }
  }
}

/// The 5 Category lists.
///
/// ** Seperated as to not make the singlton class above
/// overly complicated.

abstract class _CategoryListBase {
  List<FinanceObject> _essentialList = List(),
      _securityList = List(),
      _goalList = List(),
      _lifeStyleList = List(),
      _miscList = List();

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
      unspent += obj.cashReserve;
    }

    return unspent;
  }
}
