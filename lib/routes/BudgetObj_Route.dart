import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';

import '../models/finance_objects/BudgetObject.dart';
import '../pages/EnterTransactionPage.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class BudgetObjRoute extends StatelessWidget {
  final BudgetObject budgetObject;

  BudgetObjRoute(this.budgetObject);

  void _addTransaction(double valueEntered, BuildContext ctx) {
    Transaction transaction = budgetObject.spendCash(valueEntered);
    if (transaction != null)
      budgetObject.logTransaction(transaction);
    else
      print('transaction was invalid');
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      headerName: budgetObject.name,
      quickStatTitle: 'Remaining',
      quickStatInfo: '\$${Format.formatDouble(budgetObject.cashReserve, 0)}',
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
        TransactionHistoryPage(budgetObject),
      ],
    );
  }
}
