import 'package:flutter/material.dart';

import 'Meta/Transaction.dart';

/// Tracks all the cash flowing through the system
/// Keeping things in sync and accurate
class BudgetourReserve {
  static final BudgetourReserve _instance = BudgetourReserve._internal();

  factory BudgetourReserve() {
    return _instance;
  }

  BudgetourReserve._internal() {}

  static BudgetourReserve get clerk => _instance;

  static double _totalCash = 0;

  static double _printCash(double amount) {
    _totalCash += amount;
    return amount;
  }

  static double _expellCash(double amount) {
    _totalCash -= amount;
    return amount;
  }

  Transaction mediateTransfer(CashHolder giver, CashHolder receiver, Transaction contract) {
    if (giver.cashReserve >= contract.amount) {
      /// Take amount from giver
      giver._cashAccount -= contract.amount;

      /// Give amount to receiver
      receiver._cashAccount += contract.amount;
      
      return _validateTransaction(contract);
    }
    /// void contract
    contract = null;
    return null;
  }

  static Transaction _validateTransaction(Transaction contract) {
    contract._validate = true;
    return contract;
  }
}

/// Can bring money into the system but can't expell it
mixin CashHandler {
  double _cashAccount = 0;

  depositCash(double amount) {
    if (amount > 0) _cashAccount += BudgetourReserve._printCash(amount);
  }

  Transaction transferToHolder(CashHolder holder, double amount) {
    Transaction reciept;

    if (_cashAccount >= amount) {
      /// Remove [amount] from [_cashAccount]
      _cashAccount -= amount;

      /// Transfer [amount] to holder
      holder._cashAccount += amount;

      reciept =
          Transaction(amount: amount, description: 'transferred \$$amount');
    }
    return reciept;
  }

  double get amount => _cashAccount;
}

/// Can expell money out of the system, but can't bring it in
///
/// CashHolder can be filled however, using [BudgetReserve]'s [mediateTransfer] method
mixin CashHolder {
  double _cashAccount = 0;

  spendCash(double amount) {
    if (amount < 0)
      _cashAccount -= BudgetourReserve._expellCash(amount);
  }

  double get cashReserve => _cashAccount;
}

/// When exchanging money from any Finance Object it will be done
/// with a Transaction object.
class Transaction {
  static const String defaultMessage = '*missing note';

  Key key;
  String description;
  double amount;
  DateTime date;
  Color perceptibleColor;

  bool _validate = false;

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

  get isValid => _validate;
}