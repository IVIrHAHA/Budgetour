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
  E _stat1, _stat2;

  set firstStat(E stat) {
    this._stat1 = stat;
  }

  set secondStat(E stat) {
    this._stat2 = stat;
  }

  QuickStat getFirstStat() {
    return _stat1 != null ? determineStat(_stat1) : null;
  }

  QuickStat getSecondStat() {
    return _stat2 != null ? determineStat(_stat2) : null;
  }

  bool hasFirstStat() {
    return _stat1 != null;
  }

  bool hasSecondStat() {
    return _stat2 != null;
  }

  /// Allow [FinanceObject] to determine how [QuickStat] will
  /// be created and handled.
  ///
  /// [E] should return a [enum] diretly correlated to the specific
  /// [FinanceObject]
  QuickStat determineStat(E statType);
}
