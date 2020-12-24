import '../Transaction.dart';

mixin TransactionMixin {
  List<Transaction> _list = List<Transaction>();

  /*
   *  Manages the transaction list 
   */
  logTransaction(Transaction transaction) {
    if(_list.isEmpty) {
      _list.add(transaction);
    }
    else if(_list.first.date.compareTo(transaction.date) < 1) {
      _list.insert(0, transaction);
    }
    else {
      _list.add(transaction);
      _sortList();
    }
  }

  _sortList() {
    _list.sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> get getTransactions => _list;

  // deleteTransaction(Transaction transaction);
}
