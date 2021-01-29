import 'package:budgetour/models/Meta/QuickStat.dart';

/// To use this correctly ensure to make an [enum]
/// that directly correlates to the specific [FinanceType]
/// you are utilizing
///
/// Example:
/// ``` dart
/// enum BudgetStat {
///   allocated,
///   remaining,
///   spent
/// }
/// ```
///
/// After you have done this, include it in the extended class declaration
///
/// Expample:
/// ``` dart
/// class BudgetObject extends FinanceObject<BudgetStat>{}
/// ```
mixin StatMixin<E> {
  E firstStat, secondStat;

  QuickStat getFirstStat() {
    return firstStat != null ? determineStat(firstStat) : null;
  }

  QuickStat getSecondStat() {
    return secondStat != null ? determineStat(secondStat) : null;
  }

  bool hasFirstStat() {
    return firstStat != null;
  }

  bool hasSecondStat() {
    return secondStat != null;
  }

  E statEnumFromString(List<E> values, String enumString) {
    return values.singleWhere((element) => element.toString() == enumString,
        orElse: () => null);
  }

  /// Allow [FinanceObject] to determine how [QuickStat] will
  /// be created and handled.
  ///
  /// [E] should return a [enum] diretly correlated to the specific
  /// [FinanceObject]
  QuickStat determineStat(E statType);
}
