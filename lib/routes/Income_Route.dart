import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/Transaction.dart';
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/pages/TransactionHistoryPage.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class IncomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      headerName: 'Income',
      quickStatTitle: 'liquid',
      quickStatInfo: Format.formatDouble(CashOnHand.instance.amount, 2),
      tabTitles: [
        Text('Deposit', style: style),
        Text('History', style: style),
      ],
      tabPages: [
        EnterTransactionPage(
          /// User reported Income
          onEnterPressed: (enteredDouble, _) {
            _userEnteredIncome(enteredDouble);
          },
          headerTitle: 'Income',
          headerColorAccent: ColorGenerator.fromHex(GColors.greenish),
        ),
        TransactionHistoryPage(
          CashOnHand.instance,
          infoTileHeader: 'Monthly Deposits',
          infoValue: CashOnHand.instance.getMonthlyDeposits,
        ),
      ],
    );
  }

  _userEnteredIncome(double incomeAmount) {
    CashOnHand.instance.autoLogDeposit(incomeAmount);
  }
}
