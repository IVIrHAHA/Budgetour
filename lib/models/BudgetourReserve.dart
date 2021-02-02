import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/tools/DatabaseProvider.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:flutter/material.dart';

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

  get cashReport => _totalFromHandlers + _totalFromHolders;

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
      double trxtLink;

      if (cashObject is CashHolder) {
        trxtLink = cashObject.transactionLink;
      } else if (cashObject is CashHandler) {
        trxtLink = cashObject.transactionLink;
      }
      
      Future<List<Map>> future =
          DatabaseProvider.instance.loadTransactions(trxtLink);
      await future;
      future.then((trxtMapList) {
        /// Build Transaction Object
        trxtMapList.forEach((trxtMap) {
          Transaction trxtCopy = Transaction._fromMap(trxtMap);

          /// Make data accessable, these are copies of saved validated Transactions
          trxtCopy.transactionKey = trxtMap[TRXT_KEY];
          trxtCopy._validated = true;
          trxtList.add(trxtCopy);
        });

        return trxtList;
      });

      /// Otherwise return an empty list
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
  static Future<Transaction> _printCash(Transaction uncertifiedTrxt) async {
    if (uncertifiedTrxt._amount > 0) {
      _totalCash += uncertifiedTrxt._amount;

      /// The transaction should already have the transactionLink
      return await _validateTransaction(uncertifiedTrxt);
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
  static Future<Transaction> _expellCash(Transaction uncertifiedTrxt) async {
    if (uncertifiedTrxt._amount < 0) {
      _totalCash += uncertifiedTrxt._amount;

      /// The transaction should already have the transactionLink
      return await _validateTransaction(uncertifiedTrxt);
    }
    throw Exception('unable to perform withdrawal');
  }

  /// Only place a [Transaction] can be validated
  static Future<Transaction> _validateTransaction(Transaction contract) async {
    contract._validated = true;
    contract.transactionKey =
        await DatabaseProvider.instance.getTransactionQty();

    if (contract.transactionKey != null) {
      contract.transactionKey++;
      return contract;
    } else {
      throw Exception('Transaction was unable to be validated!');
    }
  }
}

/* -----------------------------------------------------------------------------
 * CASH HANDLER
 *------------------------------------------------------------------------------*/
/// Can bring money into the system but can't expell it
mixin CashHandler {
  double _cashAccount = 0;

  /// Links transactionHistory if there is one to the transactionHistoryTable
  /// Otherwise, return null.
  ///
  /// **Implemented here, because of the transfer methods this interface defines.
  /// Otherwise [Transaction] would have no way of obtaining the key, since
  /// this is the only place [Transaction] objects are able to be created.
  /// In addition, [Transaction] is saved regardless if [FinanceObject] utilizes
  /// [TransactionHistory] mixin.
  double get transactionLink;

  Map<String, dynamic> toMap();

  /// This brings cash into the system and provides a validated [Transaction]
  /// with [Transaction.amount] equalling the amount passed.
  ///
  /// If [this.CashHandler] has a [TransactionHistory] mixin, then saving
  /// [Transaction] reciept must be handled externally.
  /// Otherwise, this saves the reciept.
  Future<Transaction> reportIncome(double amount) async {
    Transaction reciept;

    if (amount > 0) {
      reciept = await BudgetourReserve._printCash(
          Transaction(amount, this.transactionLink));

      if (reciept != null) {
        _cashAccount += reciept.amount;

        // If this doesn't have transaction history to showcase
        // then save here
        if (!(this is TransactionHistory)) {
          DatabaseProvider.instance.insert(reciept);
        }

        // Save this handler since cashAccount has been altered
        DatabaseProvider.instance.insert(this);

        return reciept;
      } else
        return null;
    }
    return null;
  }

  /// Transfers [amount] from [this] to [holder] and provides each
  /// with a copy of the transfer with [transferReciept]. Thus,
  /// if any object has a [TransactionHistory] mixin, there is no need to
  /// use [logTransaction].
  void transferToHolder(CashHolder holder, double amount) {
    if (_cashAccount >= amount && amount > 0) {
      /// Verify with each object to agree to the transfer
      if (this.agreeToTransfer(amount) && holder.agreeToTransfer(amount)) {
        /// Remove [amount] from [_cashAccount]
        this._cashAccount -= amount;

        /// Transfer [amount] to holder
        holder._cashAccount += amount;

        this
            .transferReciept(
          BudgetourReserve._validateTransaction(
              Transaction(-amount, this.transactionLink)),
          holder,
        )
            .then((handlerReciept) {
          DatabaseProvider.instance.insert(handlerReciept).whenComplete(() {
            holder
                .transferReciept(
              BudgetourReserve._validateTransaction(
                  Transaction(amount, holder.transactionLink)),
              this,
            )
                .then((holderReceipt) {
              DatabaseProvider.instance.insert(holderReceipt).whenComplete(() {
                print('transfer completed');
              });
            });
          });
        });

        /// Save objects since both cash amounts have been altered
        DatabaseProvider.instance.insert(holder);
        DatabaseProvider.instance.insert(this);

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
  bool agreeToTransfer(double amount);

  /// When a transfer to a [CashHolder] was successfully exectuted, a copy of the
  /// transaction will relayed back to both the [CashHolder] and [CashHandler]
  ///
  /// When any changes are made to transferReciept, pass it pack, [BudgetourReserve] will
  /// archive it.
  Future<Transaction> transferReciept(
      Future<Transaction> transferReciept, CashHolder to);

  double get cashAmount => _cashAccount;
}

/* -------------------------------------------------------------------------------------
 * CASH HOLDER
 *--------------------------------------------------------------------------------------*/
/// Can expell money out of the system, but can't bring it in
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
  Future<Transaction> spendCash(double amount) async {
    Transaction withdrawlReciept;
    if (amount > 0 && _cashAccount >= amount) {
      // invert the sign to accurately represent mathematics
      withdrawlReciept = await BudgetourReserve._expellCash(
          Transaction(-amount, this.transactionLink));

      /// '+=' beacause of above statement ^^^
      if (withdrawlReciept != null) {
        _cashAccount += withdrawlReciept.amount;

        /// Save FinanceObject after cash has been spent
        DatabaseProvider.instance.insert(this);

        // If this doesn't have transaction history to showcase
        // then save here
        if (!(this is TransactionHistory)) {
          DatabaseProvider.instance.insert(withdrawlReciept);
        }
        return withdrawlReciept;
      }
      return null;
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
  bool agreeToTransfer(double transferAmount);

  /// When a transfer to a [CashHolder] was successfully exectuted, a copy of the
  /// transaction will relayed back to both the [CashHolder] and [CashHandler]
  ///
  /// When any changes are made to transferReciept, pass it pack, [BudgetourReserve] will
  /// archive it.
  Future<Transaction> transferReciept(
      Future<Transaction> transferReciept, CashHandler from);

  double get cashReserve => _cashAccount;
}

/* -------------------------------------------------------------------------------------
 * TRANSACTION
 *--------------------------------------------------------------------------------------*/
/// When exchanging money from any Finance Object it will be done
/// with a Transaction object.
class Transaction {
  static const String defaultMessage = '*missing note';

  int transactionKey;

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
      TRXT_KEY: transactionKey,
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
        other.transactionKey == this.transactionKey;
  }

  @override
  int get hashCode => super.hashCode;
}
