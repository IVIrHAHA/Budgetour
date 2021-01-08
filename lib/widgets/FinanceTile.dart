import '../models/finance_objects/FinanceObject.dart';
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
        color: financeObj.getTileColor(),
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
        ListTile(
          title: Text(
            financeObj.label_1 != null
                ? financeObj.label_1.title
                : 'no label selected',
          ),
          trailing: Text(''),
        ),
        Text(financeObj.label_2 ?? 'hello 2'),
      ],
    );
  }

  _openTile(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return financeObj.getLandingPage();
        },
      ),
    );
  }
}
