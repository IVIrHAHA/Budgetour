/*
 * Allows program to interface with all FinaceObjects
 */
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';

/// [FinanceObjectType] allows color schememing in [FinanceTile].
/// Amongst other potential uses.
enum FinanceObjectType {
  budget,
  fixed,
  fund,
  goal,
}

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject with TilePresenter{
  String name;
  final FinanceObjectType _type;
  /// For hints or messages to be displayed above [FinanceTile]
  String affirmation;

  FinanceObject(
    this._type, {
    @required this.name,
  });

  getType() {
    return _type;
  }
}
