 /*
  *  Manages the transaction list 
  */

import '../finance_objects/Transaction.dart';

mixin TransactionHistory {
  List<Transaction> _list = List<Transaction>();

  /*
   *  Logs transactions according to date. Latest to oldest. 
   */
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

  /*
   *  Gives total transaction amount for the month. 
   */
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
