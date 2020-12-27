import 'package:budgetour/models/FixedPaymentObject.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
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
      financeObject: widget.paymentObj,
      quickStatTitle: 'Pending',
      quickStatInfo: '\$ ${Format.formatDouble(widget.paymentObj.paymentAmount, 2)}',
      tabPages: [
        EnterTransactionPage(
          onEnterPressed: (amount, _) {
            setState(() {
              widget.paymentObj.paymentAmount -= amount;
              Navigator.of(context).pop();
            });
          },
          processName: 'Payment',
          processNameColor: Colors.grey,
        ),
      ],
    );
  }
}
