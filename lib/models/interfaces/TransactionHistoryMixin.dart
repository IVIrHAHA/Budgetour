import 'dart:convert';

import '../BudgetourReserve.dart';

/// Creates and manages [FinanceObject]s transaction history

import '../finance_objects/FinanceObject.dart';

mixin TransactionHistory {
  List<Transaction> _transactionsList = List<Transaction>();

  /// Logs transactions according to date. Latest to oldest.
  ///
  /// *** By default, this does not update the [FinanceObject.cashReserve]
  bool _logTransaction(Transaction transaction) {
    /// TODO: Can make this more efficient

    if (transaction.isValid && !_transactionsList.contains(transaction)) {
      // Add wherever if list is empty
      if (_transactionsList.isEmpty) {
        _transactionsList.add(transaction);
      }

      // Add to front of list if incoming transaction.date allows
      else if (_transactionsList.first.date.compareTo(transaction.date) < 1) {
        _transactionsList.insert(0, transaction);
      }

      // Otherwise, add wherever and sort the list
      //
      // *** This is where we can improve. Rather than sorting the entire list
      // should find where to place and insert there. If list is already sorted
      // to begin with.
      else {
        _transactionsList.add(transaction);
        _sortList();
      }
      return true;
    }
    return false;
  }

  /// Gives current month's total transaction amount.
  double getMonthlyStatement() {
    double amount = 0;
    _transactionsList
        .where((element) => element.date.month == DateTime.now().month)
        .forEach((element) {
      amount += element.amount;
    });

    return amount;
  }

  double getMonthlyExpenses() {
    double amount = 0;
    _transactionsList.where((element) {
      bool timeFrame = element.date.month == DateTime.now().month;
      bool transactionType = element.amount < 0;
      return timeFrame && transactionType;
    }).forEach((element) {
      amount += element.amount;
    });

    return amount;
  }

  double getMonthlyDeposits() {
    double amount = 0;
    _transactionsList.where((element) {
      bool timeFrame = element.date.month == DateTime.now().month;
      bool transactionType = element.amount > 0;
      return timeFrame && transactionType;
    }).forEach((element) {
      amount += element.amount;
    });

    return amount;
  }

  /// Sorts [_transactionsList] from latest to oldest
  _sortList() {
    _transactionsList.sort((a, b) => b.date.compareTo(a.date));
  }

  /// Here we will load the transaction history
  List<Transaction> get transactions => _transactionsList;

  /// Returns a [Future<List<Transaction>>] which contains a copy of
  /// pass [Transacion]s
  loadTransaction() async {
    Future<List<Transaction>> future =
        BudgetourReserve.clerk.obtainHistory(this);

    await future;
    future.then((trxtList) {
      trxtList.forEach((element) {
        this._logTransaction(element);
      });
    });
  }
}
