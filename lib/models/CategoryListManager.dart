import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';

class CategoryListManager extends _CategoryListBase {
  static final CategoryListManager _instance = CategoryListManager._internal();

  factory CategoryListManager() {
    return _instance;
  }

  CategoryListManager._internal() {
    _essentialList = InitTestData.dummyEssentialList;
    _securityList = new List<FinanceObject>();
    _goalList = new List<FinanceObject>();
    _lifeStyleList = new List<FinanceObject>();
    _miscList = new List<FinanceObject>();
  }

  static get instance => _instance;

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

enum CategoryType {
  essential,
  security,
  goals,
  lifestyle,
  miscellaneous,
}

/*
 *  Category list base. Used for organization 
 */
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
