import '../models/Meta/QuickStat.dart';
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
          title: Text(
              financeObj.hasFirstStat() ? financeObj.getFirstStat().title : ''),
          trailing: financeObj.hasFirstStat()
              ? _getQuickStatValue(financeObj.getFirstStat())
              : Text(''),
        ),

        // Stat Display #2
        ListTile(
          title: Text(financeObj.hasSecondStat()
              ? financeObj.getSecondStat().title
              : ''),
          trailing: financeObj.hasSecondStat()
              ? _getQuickStatValue(financeObj.getSecondStat())
              : Text(''),
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
          if (snapshot.hasData) {
            return Text(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('errr');
          } else {
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
