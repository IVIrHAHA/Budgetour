/*
 * Allows program to interface with all FinaceObjects
 */
import 'package:budgetour/models/interfaces/StatMixin.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import 'CashObject.dart';

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

  double _cashReserve;

  FinanceObject(
    this._type, {
    @required this.name,
    double cashFeed = 0,
  }) {
    // Ensure there is enough cash on hand to feed
    if (CashObject.instance.liquidAmount >= cashFeed)
      this._cashReserve = cashFeed;
    else
      this._cashReserve = 0;
  }

  getType() {
    return _type;
  }

  void deposit(double deposit) {
    if (CashObject.instance.liquidAmount > deposit) {
      _cashReserve += deposit;
      print('deposited: $deposit into $name');
    }
  }

  /// This method tracks the amount of cash this [FinanceObject] has at its disposal.
  ///
  /// If the withdrawal request is greater than the cash supply, then overdrawn amount
  /// will be returned.
  double withdraw(double withdrawlRequest) {
    _cashReserve -= withdrawlRequest;
    if (_cashReserve >= 0) {
      return 0;
    } else
      return _cashReserve;
  }

  get cashReserve => _cashReserve;
}
