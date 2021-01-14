/*
 * Allows program to interface with all FinaceObjects
 */
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/interfaces/StatMixin.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import 'CashOnHand.dart';

/// [FinanceObjectType] allows color schememing in [FinanceTile].
/// Amongst other potential uses.
enum FinanceObjectType {
  budget,
  fixed,
  fund,
  goal,
}

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject<E> with TilePresenter, StatMixin<E> {
  String name;
  final FinanceObjectType _type;

  double cashReserve;

  FinanceObject(
    this._type, {
    @required this.name,
    double cashFeed = 0,
  }) {
    // Ensure there is enough cash on hand to feed
    if (CashOnHand.instance.amount >= cashFeed)
      this.cashReserve = cashFeed;
    else
      this.cashReserve = 0;
  }

  getType() {
    return _type;
  }
}
