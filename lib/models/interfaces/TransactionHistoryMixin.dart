/// Creates and manages [FinanceObject]s transaction history

import '../finance_objects/Transaction.dart';
import '../finance_objects/FinanceObject.dart';

mixin TransactionHistory {
  List<Transaction> _transactionsList = List<Transaction>();

  /// Logs transactions according to date. Latest to oldest.
  logTransaction(Transaction transaction) {
    if (_transactionsList.isEmpty) {
      _transactionsList.add(transaction);
    } else if (_transactionsList.first.date.compareTo(transaction.date) < 1) {
      _transactionsList.insert(0, transaction);
    } else {
      _transactionsList.add(transaction);
      _sortList();
    }
  }

  /// Gives current month's total transaction amount.
  getMonthlyExpenses() {
    double amount = 0;
    _transactionsList
        .where((element) => element.date.month == DateTime.now().month)
        .forEach((element) {
      amount += element.amount;
    });

    return amount;
  }

  /// Sorts [_transactionsList] from latest to oldest
  _sortList() {
    _transactionsList.sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> get getTransactions => _transactionsList;

  // deleteTransaction(Transaction transaction);
}
