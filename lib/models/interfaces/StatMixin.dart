import '../StatManager.dart';

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
/// After you have done this include it the extended class decloration
/// 
/// Expample:
/// ``` dart
/// class BudgetObject extends FinanceObject<BudgetStat>{}
/// ```
mixin StatMixin<E> {
  E stat_1, stat_2;

  /// ```
  set firstStat(E stat) => stat_1;
  set secondStat(E stat) => stat_2;

  QuickStat getFirstStat() => determineStat(stat_1);
  QuickStat getSecondStat() => determineStat(stat_2);

  /// Allow [FinanceObject] to determine how [QuickStat] will 
  /// be created and handled.
  /// 
  /// [E] should return a [enum] diretly correlated to the specific
  /// [FinanceObject]
  QuickStat determineStat(E statType);
}
