import 'package:budgetour/objects/Transaction.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/EnhancedListTIle.dart';
import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:common_tools/StringFormater.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile({
    Key key,
    this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: EnhancedListTile(
            leading: Text(DateFormat('M/d').format(transaction.date)),
            center: Text(transaction.description),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildAmountText(transaction.amount),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(),
                ),
                Icon(Icons.more_vert),
              ],
            ),
          ),
        ),
        Divider(
          color: ColorGenerator.fromHex(GlobalValues.borderColor),
          thickness: 2,
        )
      ],
    );
  }

  Text buildAmountText(double amount) {
    Color color;

    if (amount < 0) {
      color = ColorGenerator.fromHex('#48C144');
      amount = amount * -1;
    } else {
      color = ColorGenerator.fromHex('#FF6868');
    }

    return Text(
      '\$ ' + Format.formatDouble(amount, 2),
      style: TextStyle(color: color),
    );
  }
}
