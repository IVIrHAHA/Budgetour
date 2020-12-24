import 'package:budgetour/models/BudgetObject.dart';
import 'package:budgetour/widgets/TransactionTile.dart';
import 'package:budgetour/widgets/standardized/EnhancedListTile.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatelessWidget {
  final BudgetObject budgetObject;

  TransactionHistoryPage(this.budgetObject);

  @override
  Widget build(BuildContext context) {
    int workingMonth;

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: InfoTile(
            budgetObject: budgetObject,
            infoText:
                '${Format.formatDouble(budgetObject.getMonthlyExpenses(), 2)}',
            title: 'Total Spent',
          ),
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

  /*
   *  Builds transaction list view. A list of all transactions 
   *  seperated by Month.
   */
  SingleChildScrollView _buildTransactionListView(int workingMonth) {
    return SingleChildScrollView(
      child: Column(
        children: budgetObject.getTransactions.map((transaction) {
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
