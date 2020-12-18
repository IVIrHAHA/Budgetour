import '../Transaction.dart';

mixin TransactionMixin {
  List<Transaction> list = List<Transaction>();

  logTransaction(Transaction transaction);

  // deleteTransaction(Transaction transaction);
}