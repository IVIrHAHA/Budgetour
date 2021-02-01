import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/tools/DatabaseProvider.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String TRXT_KEY = "TransactionKEY";

/// Tracks all the cash flowing through the system
/// Keeping things in sync and accurate
class BudgetourReserve {
  static final BudgetourReserve _instance = BudgetourReserve._internal();

  factory BudgetourReserve() {
    return _instance;
  }

  BudgetourReserve._internal();

  static BudgetourReserve get clerk => _instance;

  get cashReport => _totalCash;

  /// TODO: create a verify method to ensure cash amount are correct
  assign(Object cashObject, double cashAmount) {
    if (cashObject is CashHolder) {
      _totalFromHolders += cashAmount;
      cashObject._cashAccount = cashAmount;
    } else if (cashObject is CashHandler) {
      _totalFromHandlers += cashAmount;
      cashObject._cashAccount = cashAmount;
    } else {
      throw Exception('Unknown CashObject');
    }
  }

  Future<List<Transaction>> obtainHistory(Object cashObject) {
    return Future<List<Transaction>>(() async {
      List<Transaction> trxtList = List();
      if (cashObject is CashHolder) {
        Future<List<Map>> future = DatabaseProvider.instance
            .loadTransactions(cashObject.transactionLink);
        await future;
        future.then((trxtMapList) {
          /// Build Transaction Object
          trxtMapList.forEach((trxtMap) {
            Transaction trxtCopy = Transaction._fromMap(trxtMap);

            /// Make data accessable, these are copies of saved validated Transactions
            trxtCopy._transactionKey = trxtMap[TRXT_KEY];
            trxtCopy._validated = true;
            trxtList.add(trxtCopy);
          });

          return trxtList;
        });
      }
      return trxtList;
    });
  }

  static double _totalCash = 0;
  static double _totalFromHandlers = 0;
  static double _totalFromHolders = 0;

  /// Add to [_totalCash] by the amount passed.
  /// Then return a validatedTransaction where amount is accessable
  /// outside this class.
  ///
  /// ** This is the only method that can add to [_totalCash]
  static Transaction _printCash(Transaction uncertifiedTrxt) {
    if (uncertifiedTrxt._amount > 0) {
      _totalCash += uncertifiedTrxt._amount;

      /// The transaction should already have the transactionLink
      return _validateTransaction(uncertifiedTrxt);
    }
    throw Exception('when depositing, ensure amount is greater than 0');
  }

  /// Subtract from [_totalCash] by [Transaction.amount] passed.
  /// Then return a validatedTransaction where amount is accessable
  /// outside this class.
  ///
  /// ** This is the only method that can subtract from [_totalCash]
  ///
  /// ** IMPORTANT: [Transaction.amount] needs to be negative in order
  static Transaction _expellCash(Transaction uncertifiedTrxt) {
    if (uncertifiedTrxt._amount < 0) {
      _totalCash += uncertifiedTrxt._amount;

      /// The transaction should already have the transactionLink
      return _validateTransaction(uncertifiedTrxt);
    }
    throw Exception('unable to perform withdrawal');
  }

  /// Only place a [Transaction] can be validated
  static Transaction _validateTransaction(Transaction contract) {
    contract._validated = true;
    _saveTransaction(contract);
    return contract;
  }

  /// ONLY TO BE USED BY [_validateTransaction]
  static _saveTransaction(Transaction transaction) async {
    Future<int> future = DatabaseProvider.instance.getTransactionQty();
    await future;
    future.then((trxtQTY) async {
      transaction._transactionKey = trxtQTY + 1;
      print(
        'saving ${transaction.pertainenceID}' +
            '${transaction._transactionKey} ' +
            'des: ${transaction.description}',
      );
      await DatabaseProvider.instance.insert(transaction);
    });
  }
}

/* -----------------------------------------------------------------------------
 * CASH HANDLER
 *------------------------------------------------------------------------------*/
/// Can bring money into the system but can't expell it
mixin CashHandler {
  double _cashAccount = 10010;

  /// Links transactionHistory if there is one to the transactionHistoryTable
  /// Otherwise, return null.
  ///
  /// **Implemented here, because of the transfer methods this interface defines.
  /// Otherwise [Transaction] would have no way of obtaining the key, since
  /// this is the only place [Transaction] objects are able to be created.
  /// In addition, [Transaction] is saved regardless if [FinanceObject] utilizes
  /// [TransactionHistory] mixin.
  double get transactionLink;

  /// This brings cash into the system and provides a validated [Transaction]
  /// with [Transaction.amount] equalling the amount passed.
  Transaction reportIncome(double amount) {
    Transaction reciept;

    if (amount > 0) {
      reciept = BudgetourReserve._printCash(
          Transaction(amount, this.transactionLink));
      _cashAccount += reciept.amount;
    }
    return reciept;
  }

  /// Transfers [amount] from [this] to [holder] and provides each
  /// with a copy of the transfer with [transferReciept]. Thus,
  /// if any object has a [TransactionHistory] mixin, there is no need to
  /// use [logTransaction].
  void transferToHolder(CashHolder holder, double amount) {
    if (_cashAccount >= amount && amount > 0) {
      /// Verify with each object to agree to the transfer
      if (this.acceptTransfer(amount) && holder.acceptTransfer(amount)) {
        /// Remove [amount] from [_cashAccount]
        this._cashAccount -= amount;

        /// Transfer [amount] to holder
        holder._cashAccount += amount;

        this.transferReciept(
          BudgetourReserve._validateTransaction(
              Transaction(-amount, this.transactionLink)),
          holder,
        );

        holder.transferReciept(
          BudgetourReserve._validateTransaction(
              Transaction(amount, holder.transactionLink)),
          this,
        );

        /// Save object after transfer has been completed
        /// TODO: change to an update query function
        FinanceObject object = (holder as FinanceObject);
        DatabaseProvider.instance.insert(object);

        return;
      } else {
        throw PartisanException('Both parties did not agree to transfer');
      }
    }
    throw InvalidTransferException('The transfer was invalid');
  }

  /// Determine whether [this] is willing to accept [amount]
  ///
  /// *** Executes before [CashHandler.transferToHolder]
  bool acceptTransfer(double amount);

  /// When a transfer to a [CashHolder] was successfully exectuted, a copy of the
  /// transaction will relayed back to both the [CashHolder] and [CashHandler]
  void transferReciept(Transaction transferReciept, CashHolder to);

  double get cashAmount => _cashAccount;
}

/* -------------------------------------------------------------------------------------
 * CASH HOLDER
 *--------------------------------------------------------------------------------------*/
/// Can expell money out of the system, but can't bring it in
///
/// CashHolder can be filled however, using [BudgetReserve]'s [mediateTransfer] method
mixin CashHolder {
  double _cashAccount = 0;

  /// Links transactionHistory if there is one to the transactionHistoryTable
  /// Otherwise, return null.
  ///
  /// **Implemented here, because of the transfer methods this interface defines.
  /// Otherwise [Transaction] would have no way of obtaining the key, since
  /// this is the only place [Transaction] objects are able to be created.
  double get transactionLink;

  /// Returns a validated [Transaction] given a valid [amount]. Otherwise, return null.
  Transaction spendCash(double amount) {
    Transaction withdrawlReciept;
    if (amount > 0 && _cashAccount >= amount) {
      // invert the sign to accurately represent mathematics
      withdrawlReciept = BudgetourReserve._expellCash(
          Transaction(-amount, this.transactionLink));

      /// '+=' beacause of above statement ^^^
      _cashAccount += withdrawlReciept.amount;

      /// Save FinanceObject after cash has been spent
      DatabaseProvider.instance.insert(this);

      return withdrawlReciept;
    }
    return null;
  }

  /// When a transfer has been initiated, as the recipient,
  /// [this] should specify an amount to be transferred. Default is 0.
  ///
  /// This is not called during the [CashHandler.transferToHolder] process.
  /// Rather, it is referred to explicitly.
  ///
  /// *** This only acts as a suggestion
  double suggestedTransferAmount() {
    return 0;
  }

  /// Determine whether [this] is willing to accept [transferAmount]
  ///
  /// *** Executes before [CashHandler.transferToHolder]
  bool acceptTransfer(double transferAmount);

  /// When a transfer to a [CashHolder] was successfully exectuted, a copy of the
  /// transaction will relayed back to both the [CashHolder] and [CashHandler]
  void transferReciept(Transaction transferReciept, CashHandler from);

  double get cashReserve => _cashAccount;
}

/* -------------------------------------------------------------------------------------
 * TRANSACTION
 *--------------------------------------------------------------------------------------*/
/// When exchanging money from any Finance Object it will be done
/// with a Transaction object.
class Transaction {
  static const String defaultMessage = '*missing note';

  int _transactionKey;

  Key key;
  final double pertainenceID;
  final double _amount;
  String description;
  DateTime date;
  Color perceptibleColor;

  bool _validated = false;

  /// Defaults transaction [date] to [DateTime.now()]
  Transaction(
    this._amount,
    this.pertainenceID, {
    this.description = defaultMessage,
    this.date,
    this.perceptibleColor,
  }) {
    this.date = this.date ?? DateTime.now();
  }

  get amount => _validated ? _amount : null;

  bool isPerceptible() {
    return perceptibleColor != null;
  }

  get isValid => _validated;

  Map<String, dynamic> toMap() {
    return {
      '${DbNames.trxt_id}': pertainenceID,
      '${DbNames.trxt_amount}': amount,
      '${DbNames.trxt_description}': description,
      '${DbNames.trxt_date}': date.millisecondsSinceEpoch,
      '${DbNames.trxt_color}':
          perceptibleColor != null ? perceptibleColor.value : null,
      TRXT_KEY: _transactionKey,
    };
  }

  static Transaction _fromMap(Map map) {
    return Transaction(map['${DbNames.trxt_amount}'], map['${DbNames.trxt_id}'],
        description: map['${DbNames.trxt_description}'],
        date: DateTime.fromMillisecondsSinceEpoch(map['${DbNames.trxt_date}']),
        perceptibleColor: map['${DbNames.trxt_color}'] != null
            ? Color(map['${DbNames.trxt_color}'])
            : null);
  }

  @override
  bool operator ==(other) {
    return (other is Transaction) &&
        other._transactionKey == this._transactionKey;
  }

  @override
  int get hashCode => super.hashCode;
}
