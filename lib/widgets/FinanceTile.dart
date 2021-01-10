import 'package:budgetour/models/StatManager.dart';
import 'package:common_tools/StringFormater.dart';

import '../models/finance_objects/FinanceObject.dart';
import '../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  @override
  Widget build(BuildContext context) {
    if (financeObj.name == 'Food') print('building food');
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
        // Main Title
        ListTile(
          leading: Text(financeObj.name),
          trailing: Icon(Icons.more_vert),
        ),

        // Stat Display #1
        ListTile(
          title: Text(financeObj.statBundle.stat1.title),
          trailing: _getQuickStatValue(financeObj.statBundle.stat1),
        ),

        // Stat Display #2
        ListTile(
          title: Text(financeObj.statBundle.stat2.title),
          trailing: _getQuickStatValue(financeObj.statBundle.stat2),
        ),
      ],
    );
  }

  _getQuickStatValue(QuickStat stat) {
    if (!stat.hasToEvaluate()) {
      return Text('${Format.formatDouble(stat.value, 2)}');
    } else {
      return FutureBuilder(
        future: stat.evaluateValue,
        builder: (_, snapshot) {
          if(snapshot.hasData) {
            return Text('${Format.formatDouble(snapshot.data, 2)}');
          }
          else if(snapshot.hasError) {
            return Text('errr');
          }
          else {
            return Text('berr');
          }
        },
      );
    }
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
