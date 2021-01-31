import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/tools/DatabaseProvider.dart';
import 'package:budgetour/tools/GlobalValues.dart';

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

  _verifyInsertion(
      List<FinanceObject> list, FinanceObject financeObject, bool loading) async {
    if (!list.any((element) => element.id == financeObject.id)) {
      /// Save object, assuming it was created and not loaded
      if (!loading) {
        await DatabaseProvider.instance.insert(financeObject).whenComplete(() {
          list.add(financeObject);
        });
      }
      /// If retrieving from database, no need to save therefore add directly to the list
      else
      list.add(financeObject);
    }
  }

  /// Adds [FinanceObject] to specified Category list using [CategoryType]
  add(FinanceObject what, CategoryType where, {bool loading = false}) {
    switch (where) {
      case CategoryType.essential:
        _verifyInsertion(_essentialList, what, loading);
        break;

      case CategoryType.security:
        _verifyInsertion(_securityList, what, loading);
        break;

      case CategoryType.goals:
        _verifyInsertion(_goalList, what, loading);
        break;

      case CategoryType.lifestyle:
        _verifyInsertion(_lifeStyleList, what, loading);
        break;

      case CategoryType.miscellaneous:
        _verifyInsertion(_miscList, what, loading);
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

  List<FinanceObject> getAllObjects() {
    List<FinanceObject> list = List();

    list.addAll(_essentialList);
    list.addAll(_securityList);
    list.addAll(_goalList);
    list.addAll(_lifeStyleList);
    list.addAll(_miscList);
    return list;
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
