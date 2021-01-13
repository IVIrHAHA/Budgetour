/*
 * When exchanging money from any Finance Object it will be done
 * with a Transaction object.
 * 
 * In this case a deposit into the account is negative
 * while a withdrawal is positive.
 */

import 'package:flutter/material.dart';

class Transaction {
  static const String defaultMessage = '*missing note';

  Key key;
  String description;
  double amount;
  DateTime date;
  Color perceptibleColor;

  /// Defaults transaction [date] to [DateTime.now()]
  Transaction({
    this.description = defaultMessage,
    @required this.amount,
    this.date,
    this.perceptibleColor,
  }) {
    this.date = this.date ?? DateTime.now();
  }

  bool isImportant() {
    return perceptibleColor != null;
  }
}
