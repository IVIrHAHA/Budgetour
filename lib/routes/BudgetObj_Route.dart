import 'package:budgetour/models/BudgetourReserve.dart';
import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/tools/DatabaseProvider.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';

import '../models/finance_objects/BudgetObject.dart';
import '../pages/EnterTransactionPage.dart';
import 'package:flutter/material.dart';

class BudgetObjRoute extends StatelessWidget {
  final BudgetObject budgetObject;

  BudgetObjRoute(this.budgetObject) {
    _loadHistory();
  }

  _loadHistory() async {
    await this.budgetObject.loadTransaction();
  }

  void _addTransaction(double valueEntered, BuildContext ctx) async {
    Transaction transaction = await budgetObject.spendCash(valueEntered);
    DatabaseProvider.instance.insert(transaction);
    if (transaction != null) {
      Navigator.of(ctx).pop();
    } else
      /// TODO: TELL USER NOT ENOUGH FUNDS TO COVER TRANSACTION
      print('transaction was invalid');
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      headerName: budgetObject.name,
      stat1: budgetObject.determineStat(BudgetStat.remaining),
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
