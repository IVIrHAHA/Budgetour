import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class FixedPaymentObjRoute extends StatelessWidget {
  final FixedPaymentObject paymentObj;

  FixedPaymentObjRoute(this.paymentObj);

  @override
  Widget build(BuildContext context) {
    return MyAppBarView(
      headerName: paymentObj.name,
      stat1: paymentObj.determineStat(FixedPaymentStats.monthlyPayment),
      tabPages: [
        Column(
          children: [
            Expanded(
              flex: 1,
              child: InfoTile(
                title: paymentObj.isPaid ? 'paid' : 'available funds',
                infoText: '\$ ${Format.formatDouble(paymentObj.cashReserve, 2)}',
                titleColor: paymentObj.isPaid ? Colors.green : Colors.red,
              ),
            ),
            Expanded(
              flex: 12,
              child: EnterTransactionPage(
                initialValue: paymentObj.cashReserve,
                /// Making the payment
                onEnterPressed: (amount, _) {
                  if (amount != null) {
                    paymentObj.spendCash(amount);
                    Navigator.of(context).pop();
                  }
                },
                headerTitle: 'Payment',
                headerColorAccent: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
