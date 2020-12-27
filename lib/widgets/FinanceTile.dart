import '../models/BudgetObject.dart';
import '../models/FinanceObject.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  Color _determineTileColor() {
    if (financeObj is BudgetObject) {
      BudgetObject obj = financeObj;
      if (obj.isOverbudget())
        return ColorGenerator.fromHex(GColors.warningColor);
    }

    return ColorGenerator.fromHex(GColors.neutralColor);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openTile(context);
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

  openTile(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) {
        return BudgetObjRoute(financeObj);
      },
    ));
  }
}
