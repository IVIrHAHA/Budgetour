import '../Transaction.dart';

mixin TransactionMixin {
  List<Transaction> _list = List<Transaction>();

  logTransaction(Transaction transaction){
    _list.add(transaction);
  }

  List<Transaction> get getTransactions => _list;

  // deleteTransaction(Transaction transaction);
}