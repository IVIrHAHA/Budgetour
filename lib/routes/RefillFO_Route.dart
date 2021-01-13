import 'package:budgetour/models/finance_objects/CashObject.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class RefillObjectPage extends StatelessWidget {
  final FinanceObject financeObj;
  final Function(bool refilled) onRefillComplete;

  RefillObjectPage(this.financeObj, {this.onRefillComplete});

  @override
  Widget build(BuildContext context) {
    return MyAppBarView(
      headerName: financeObj.name,
      quickStatTitle: financeObj.getFirstStat().title,
      quickStatInfo: financeObj.getFirstStat().value.toString(),
      tabPages: [
        Column(
          children: [
            Expanded(
              flex: 1,
              child: InfoTile(
                title: 'Unallocated',
                infoText:
                    '\$ ${Format.formatDouble(CashOnHand.instance.amount, 2)}',
                infoTextColor: Colors.green,
              ),
            ),
            Expanded(
              flex: 12,
              child: EnterTransactionPage(
                onEnterPressed: (amount, _) {
                  if(onRefillComplete != null) {
                    onRefillComplete(financeObj.deposit(amount));
                  }
                  else {
                    financeObj.deposit(amount);
                  }
                  Navigator.of(context).pop();
                },
                headerTitle: 'Refill',
                headerColorAccent: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
