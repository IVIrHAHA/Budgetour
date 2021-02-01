import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class IncomeRoute extends StatelessWidget {
  final CashOnHand cashOnHand = CashOnHand.instance;

  IncomeRoute() {
    cashOnHand.loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      headerName: 'Income',
      stat1: QuickStat(
        title: 'Cash On Hand',
        lazyValue: '\$ ${Format.formatDouble(cashOnHand.cashAmount, 0)}',
      ),
      tabTitles: [
        Text('Deposit', style: style),
        Text('History', style: style),
      ],
      tabPages: [
        EnterTransactionPage(
          /// User reported Income
          onEnterPressed: (enteredDouble, _) {
            _userEnteredIncome(enteredDouble);
            Navigator.of(context).pop();
          },
          headerTitle: 'Income',
          headerColorAccent: ColorGenerator.fromHex(GColors.greenish),
        ),
        TransactionHistoryPage(
          cashOnHand,
          infoTileHeader: 'Monthly Deposits',
          infoValue: cashOnHand.getMonthlyDeposits,
        ),
      ],
    );
  }

  _userEnteredIncome(double incomeAmount) {
    cashOnHand.autoLogDeposit(incomeAmount);
  }
}
