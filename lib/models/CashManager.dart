import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:flutter/material.dart';

/// Tracks all the cash flowing through the system
/// Keeping things in sync and accurate
class BudgetourReserve {
  static final BudgetourReserve _instance = BudgetourReserve._internal();

  factory BudgetourReserve() {
    return _instance;
  }

  BudgetourReserve._internal() {}

  static BudgetourReserve get clerk => _instance;

  get cashReport => _totalCash;

  static double _totalCash = 0;

  /// Add to [_totalCash] by the amount passed.
  /// Then return a validatedTransaction where amount is accessable
  /// outside this class.
  ///
  /// ** This is the only method that can add to [_totalCash]
  static Transaction _printCash(Transaction transaction) {
    if (transaction._amount > 0) {
      _totalCash += transaction._amount;
      return _validateTransaction(transaction);
    }
    throw Exception('when depositing, ensure amount is greater than 0');
  }

  /// Subtract from [_totalCash] by [Transaction.amount] passed.
  /// Then return a validatedTransaction where amount is accessable
  /// outside this class.
  ///
  /// ** This is the only method that can subtract from [_totalCash]
  ///
  /// ** IMPORTANT: [_expellCash] will make [Transaction.amount] negative
  static Transaction _expellCash(Transaction transaction) {
    if (transaction._amount > 0) {
      _totalCash -= transaction._amount;
      return _validateTransaction(Transaction._copy(transaction, -transaction._amount));
    }
    throw Exception('when withdrawing, ensure amount is greater than 0');
  }

  /// THIS IS ACTUALLY NOT BEING USED ANYMORE
  /// Mediate the transfer of cash between two [CashHolder] objects.
  /// This is useful in the case two [FinanceObject] objects want to exchange
  /// resources.
  @deprecated
  Transaction mediateTransfer(
      CashHolder giver, CashHolder receiver, double amount) {
    if (giver._cashAccount >= amount && amount > 0) {
      /// Take amount from giver
      giver._cashAccount = giver._cashAccount - amount;

      /// Give amount to receiver
      receiver._cashAccount = receiver._cashAccount + amount;
      return _validateTransaction(Transaction(amount, null));
    }

    /// void contract
    throw Exception('not a valid transfer request');
  }

  /// Only place a [Transaction] can be validated
  static Transaction _validateTransaction(Transaction contract) {
    contract._validated = true;
    return contract;
  }
}

/* -----------------------------------------------------------------------------
 * CASH HANDLER
 *------------------------------------------------------------------------------*/
/// Can bring money into the system but can't expell it
mixin CashHandler {
  double _cashAccount = 0;

  /// Links transactionHistory if there is one to the transactionHistoryTable
  /// Otherwise, return null
  double get transactionLink;

  /// This brings cash into the system and provides a validated [Transaction]
  /// with [Transaction.amount] equalling the amount passed.
  Transaction reportIncome(double amount) {
    Transaction reciept;

    if (amount > 0) {
      reciept = BudgetourReserve._printCash(Transaction(amount, this.transactionLink));
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
          BudgetourReserve._validateTransaction(Transaction(-amount, this.transactionLink)),
          holder,
        );

        holder.transferReciept(
          BudgetourReserve._validateTransaction(
              Transaction(amount, holder.transactionLink)),
          this,
        );
        return;
      } else {
        throw PartisanException('Both parties did not agree to transfer');
      }
    }
    throw InvalidTransferException('The transfer was invalid');
  }

  /// Finishes executing before [CashHandler.transferToHolder]
  bool acceptTransfer(double amount);
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
  double get transactionLink;

  /// Returns a validated [Transaction] given a valid [amount]. Otherwise, return null.
  Transaction spendCash(double amount) {
    Transaction withdrawlReciept;
    if (amount > 0 && _cashAccount >= amount) {
      withdrawlReciept = BudgetourReserve._expellCash(Transaction(amount, this.transactionLink));

      /// '+=' beacuse [BudgetourReserve._expellCash(amount)] inverts [Transaction.amount]
      _cashAccount += withdrawlReciept.amount;
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
  bool acceptTransfer(double transferAmount);

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

  Key key;
  final double pertainenceID;
  String description;
  final double _amount;
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

  bool makePerceptible() {
    return perceptibleColor != null;
  }

  get isValid => _validated;

  static Transaction _copy(Transaction transaction, double newAmount) {
    return Transaction(
      newAmount,
      transaction.pertainenceID,
      description: transaction.description,
      date: transaction.date,
      perceptibleColor: transaction.perceptibleColor,
    );
  }
}
