import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class FixedPaymentObjRoute extends StatefulWidget {
  final FixedPaymentObject paymentObj;

  FixedPaymentObjRoute(this.paymentObj);

  @override
  _FixedPaymentObjRouteState createState() => _FixedPaymentObjRouteState();
}

class _FixedPaymentObjRouteState extends State<FixedPaymentObjRoute> {
  @override
  Widget build(BuildContext context) {
    return MyAppBarView(
      headerName: widget.paymentObj.name,
      quickStatTitle: 'Pending',
      quickStatInfo: '\$ ${Format.formatDouble(
        widget.paymentObj.monthlyFixedPayment - widget.paymentObj.paymentAmount,
        2,
      )}',
      tabPages: [
        Column(
          children: [
            Expanded(
              flex: 1,
              child: InfoTile(
                title: widget.paymentObj.isPaid() ? 'paid' : 'pending payment',
                titleColor:
                    widget.paymentObj.isPaid() ? Colors.green : Colors.red,
              ),
            ),
            Expanded(
              flex: 12,
              child: EnterTransactionPage(
                onEnterPressed: (amount, _) {
                  setState(() {
                    if (amount != null) {
                      widget.paymentObj.paymentAmount = amount;
                      Navigator.of(context).pop();
                    }
                  });
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
