import '../models/finance_objects/FixedPaymentObject.dart';
import '../routes/FixedPaymentObj_route.dart';
import '../models/finance_objects/FinanceObject.dart';
import '../models/finance_objects/BudgetObject.dart';
import '../routes/BudgetObj_Route.dart';
import '../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openTile(context);
      },
      child: Card(
        color: _determineTileColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: ColorGenerator.fromHex(GColors.borderColor)),
        ),
        margin: EdgeInsets.all(8.0),
        child: buildContents(),
      ),
    );
  }

  Column buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Text(financeObj.name),
          trailing: Icon(Icons.more_vert),
        ),
        Text(financeObj.label_1 ?? ''),
        Text(financeObj.label_2 ?? ''),
      ],
    );
  }

  Color _determineTileColor() {
    switch (financeObj.getType()) {
      // BudgetObject
      case FinanceObjectType.budget:
        if ((financeObj as BudgetObject).isOverbudget())
          return ColorGenerator.fromHex(GColors.warningColor);

        break;

      // Fixed Payment Object
      case FinanceObjectType.fixed:
        return (financeObj as FixedPaymentObject).isPaid()
            ? ColorGenerator.fromHex(GColors.positiveColor)
            : ColorGenerator.fromHex(GColors.neutralColor);
    }

    return ColorGenerator.fromHex(GColors.neutralColor);
  }

  _openTile(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          switch (financeObj.getType()) {
            case FinanceObjectType.budget:
              return BudgetObjRoute(financeObj);
              break;

            case FinanceObjectType.fixed:
              return FixedPaymentObjRoute(financeObj);
              break;

            default:
              throw Exception('UNKNOWN FINANCE_OBJECT_TYPE');
          }
        },
      ),
    );
  }
}
