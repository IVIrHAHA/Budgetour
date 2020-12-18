import 'package:budgetour/objects/FinanceObject.dart';
import 'package:budgetour/routes/BudgetObj_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openTile(context);
      },
      child: Card(
        color: ColorGenerator.fromHex(GlobalValues.neutralColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: ColorGenerator.fromHex(GlobalValues.borderColor)),
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
