/*
 * Allows program to interface with all FinaceObjects
 */
import 'package:budgetour/models/interfaces/StatMixin.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import '../BudgetourReserve.dart';

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject<E> with CashHolder, TilePresenter, StatMixin<E> {
  String name;

  double _objectID;

  /// What category this instance pertains to
  final int categoryID;

  FinanceObject({
    @required this.name,
    @required this.categoryID,
  }) {
    this._objectID = double.parse(('${this.name.hashCode}.${this.categoryID}'));
  }

  /// Gets json representative of the financeObject. This way, all finance objects
  /// can be stored in a single table where only key values can be queried via sql.
  /// However, the entire (child) object will be stored as a json.
  toJson();

  double get id => this._objectID;
}
