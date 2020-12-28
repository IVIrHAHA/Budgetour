/*
 * Allows FinanceTile to interface with all FinaceObjects easily
 */

import 'package:flutter/material.dart';

abstract class FinanceObject {
  final FinanceObjectType _type;
  String affirmation;
  String name, label_1, label_2;

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

enum FinanceObjectType {
  budget,
  fixed,
  fund,
}
