import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';

import '../models/BudgetObject.dart';
import '../models/Transaction.dart';
import '../pages/EnterTransactionPage.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class BudgetObjRoute extends StatefulWidget {
  final BudgetObject budgetObject;

  BudgetObjRoute(this.budgetObject);

  @override
  _BudgetObjRouteState createState() => _BudgetObjRouteState();
}

class _BudgetObjRouteState extends State<BudgetObjRoute> {
  _addTransaction(Transaction transaction) {
    setState(() {
      transaction.description = 'new transaction';
      widget.budgetObject.logTransaction(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      financeObject: widget.budgetObject,
      quickStatTitle: 'Remaining',
      quickStatInfo:
          '\$${Format.formatDouble(widget.budgetObject.currentBalance, 0)}',
      tabTitles: [
        Text(
          'Withdraw',
          style: style,
        ),
        Text(
          'History',
          style: style,
        ),
      ],
      tabPages: [
        // Withdraw Page
        EnterTransactionPage(_addTransaction),

        // History Page
        TransactionHistoryPage(widget.budgetObject),
      ],
    );
  }
}
