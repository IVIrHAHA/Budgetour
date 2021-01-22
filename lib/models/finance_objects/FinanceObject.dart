/*
 * Allows program to interface with all FinaceObjects
 */
import 'package:budgetour/models/interfaces/StatMixin.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import '../CashManager.dart';

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject<E> with CashHolder, TilePresenter, StatMixin<E> {
  String name;

  FinanceObject({
    @required this.name,
  });

  Map<String, dynamic> toMap();

  FinanceObject.fromMap(Map<String, dynamic> map);
}
