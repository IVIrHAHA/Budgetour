import 'package:budgetour/models/BudgetourReserve.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/EnhancedListTile.dart';
import 'package:common_tools/ColorGenerator.dart';
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
          color: ColorGenerator.fromHex(GColors.borderColor),
          thickness: 2,
        )
      ],
    );
  }

  Text buildAmountText(double amount) {
    Color color;

    if (amount > 0) {
      color = ColorGenerator.fromHex(GColors.positiveNumber);
    } else {
      color = ColorGenerator.fromHex(GColors.negativeNumber);
      amount = amount * -1;
    }

    return Text(
      '\$ ' + Format.formatDouble(amount, 2),
      style: TextStyle(
        color: transaction.perceptibleColor ?? color,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
