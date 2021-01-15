import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';

import '../models/finance_objects/BudgetObject.dart';
import '../tools/GlobalValues.dart';
import '../widgets/TransactionTile.dart';
import '../widgets/standardized/EnhancedListTile.dart';
import '../widgets/standardized/InfoTile.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays [Transaction] history
class TransactionHistoryPage extends StatelessWidget {
  final TransactionHistory history;
  final String infoTileHeader;
  final Function infoValue;

  TransactionHistoryPage(this.history, {this.infoTileHeader, this.infoValue});

  @override
  Widget build(BuildContext context) {
    int workingMonth;

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: _formatInfoTile(),
        ),
        Expanded(
          flex: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Heading
                Flexible(
                  flex: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Transaction History',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Icon(Icons.unfold_more)
                            ],
                          ),
                        ),
                        EnhancedListTile(
                          leading: Text('date'),
                          center: Text('note'),
                          trailing: Text('amount'),
                        )
                      ],
                    ),
                  ),
                ),

                // Transaction List
                Flexible(
                  flex: 1,
                  child: _buildTransactionListView(workingMonth),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InfoTile _formatInfoTile() {
    double expensesTotal =
        infoValue != null ? infoValue() : history.getMonthlyExpenses();
    bool isNegative = false;

    if (expensesTotal < 0) {
      expensesTotal = expensesTotal * -1;
      isNegative = true;
    }

    return InfoTile(
      infoText: '\$ ${Format.formatDouble(expensesTotal, 2)}',
      infoTextColor: ColorGenerator.fromHex(
          isNegative ? GColors.negativeNumber : GColors.greenish),
      title: infoTileHeader ?? 'Total Spent',
    );
  }

  /// Builds transaction list view. A list of all transactions
  /// seperated by Month.
  SingleChildScrollView _buildTransactionListView(int workingMonth) {
    return SingleChildScrollView(
      child: Column(
        children: history.getTransactions.map((transaction) {
          // Keep working month the same if already assigned
          // otherwise working month goes to first element in list
          workingMonth = workingMonth ?? transaction.date.month;

          bool monthChanged = false;
          // Month has changed
          if (transaction.date.month != workingMonth) {
            monthChanged = true;
            workingMonth = transaction.date.month;
          }

          return monthChanged
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:

                          /// (Full name of month) + (*space*) + (year)
                          Text(DateFormat('LLLL y').format(transaction.date)),
                    ),
                    TransactionTile(
                      transaction: transaction,
                    ),
                  ],
                )
              : TransactionTile(transaction: transaction);
        }).toList(),
      ),
    );
  }
}
