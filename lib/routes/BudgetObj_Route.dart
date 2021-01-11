import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';

import '../models/finance_objects/BudgetObject.dart';
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
  void _addTransaction(double valueEntered, BuildContext ctx) {
    setState(() {
      Transaction transaction = Transaction(amount: valueEntered);
      widget.budgetObject.logTransaction(transaction);
    });

    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      headerName: widget.budgetObject.name,
      quickStatTitle: 'Remaining',
      quickStatInfo:
          '\$${Format.formatDouble(widget.budgetObject.currentBalance, 0)}',
      tabTitles: [
        Text('Withdraw', style: style),
        Text('History', style: style),
      ],
      tabPages: [
        // Transaction Page
        EnterTransactionPage(
          onEnterPressed: _addTransaction,
          headerTitle: 'Withdraw',
          headerColorAccent: ColorGenerator.fromHex(GColors.redish),
        ),

        // History Page
        TransactionHistoryPage(widget.budgetObject),
      ],
    );
  }
}
