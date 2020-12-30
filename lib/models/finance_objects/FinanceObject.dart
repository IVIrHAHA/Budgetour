/*
 * Allows program to interface with all FinaceObjects
 */

import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import '../../widgets/standardized/MyAppBarView.dart';

/// [FinanceObjectType] allows color schememing in [FinanceTile].
/// Amongst other potential uses.
enum FinanceObjectType {
  budget,
  fixed,
  fund,
  goal,
}

abstract class FinanceObject {
  String name;
  final FinanceObjectType _type;
  /// For hints or messages to be displayed above [FinanceTile]
  String affirmation;
  /// Labels to be displayed in [MyAppBarView] or on the face of a [FinanceTile]
  String label_1, label_2;

  FinanceObject(
    this._type, {
    @required this.name,
    this.label_1,
    this.label_2,
  });

  getType() {
    return _type;
  }
}
