import 'package:budgetour/routes/RefillFO_Route.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Affirmation Title
          Expanded(
            flex: 0,
            child: Padding(
              /// Use 16.0 because [ListTile] default to 16.0
              padding: const EdgeInsets.only(
                left: 16.0,
                top: GlobalValues.financeTileMargin,
              ),
              child: financeObj.getAffirmation() ?? Text(''),
            ),
          ),

          /// Card Contents
          Expanded(
            flex: 1,
            child: DragTarget<double>(
              onWillAccept: (unallocatedCash) => unallocatedCash > 0,
              onAccept: (_) {
                /// Launch Refilling page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return RefillObjectPage(financeObj);
                }));
              },
              builder: (ctx, candidates, rejects) {
                return candidates.length > 0 ? _buildCard() : _buildCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      margin: const EdgeInsets.all(GlobalValues.financeTileMargin),
      color: financeObj.getTileColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
        side: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: ColorGenerator.fromHex(GColors.borderColor)),
      ),
      child: buildContents(),
    );
  }

  Widget buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Title
        Flexible(
          flex: 3,
          child: ListTile(
            title: Text(financeObj.name),
            trailing: Icon(Icons.more_vert),
          ),
        ),

        // Stat Display #1
        Flexible(
          flex: 3,
          child: ListTile(
            title: Text(financeObj.hasFirstStat()
                ? financeObj.getFirstStat().title
                : '', overflow: TextOverflow.fade, softWrap: false,),
            trailing: financeObj.hasFirstStat()
                ? financeObj.getFirstStat().getValueToString()
                : Text(''),
          ),
        ),

        // Stat Display #2
        Flexible(
          flex: 3,
          child: ListTile(
            title: Text(financeObj.hasSecondStat()
                ? financeObj.getSecondStat().title
                : ''),
            trailing: financeObj.hasSecondStat()
                ? financeObj.getSecondStat().getValueToString()
                : Text(''),
          ),
        ),
      ],
    );
  }

  /// Use [QuickStat.getValueToString]
  @deprecated
  // ignore: unused_element
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
