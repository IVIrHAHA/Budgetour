 /*
  *  Manages the transaction list 
  */

import '../Transaction.dart';

mixin TransactionMixin {
  List<Transaction> _list = List<Transaction>();

  logTransaction(Transaction transaction) {
    if (_list.isEmpty) {
      _list.add(transaction);
    } else if (_list.first.date.compareTo(transaction.date) < 1) {
      _list.insert(0, transaction);
    } else {
      _list.add(transaction);
      _sortList();
    }
  }

  getMonthlyExpenses() {
    double amount = 0;
    _list.where((element) => element.date.month == DateTime.now().month).forEach((element) {
      amount += element.amount;
    });

    return amount;
  }

  _sortList() {
    _list.sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> get getTransactions => _list;

  // deleteTransaction(Transaction transaction);
}
