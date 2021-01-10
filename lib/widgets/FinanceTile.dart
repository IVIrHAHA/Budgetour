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

        // Quick Stat Display #1
        ListTile(
          title: Text('Title'),
          trailing: Text('Value'),
        ),

        // Quick Stat Display #2
        ListTile(
          title: Text('Title'),
          trailing: Text('Values'),
        ),
      ],
    );
  }

  /// dart```
  /// _getQuickStatValue(QickStat obj) {
  ///   if(obj.getValue is Future){
  ///
  ///    return FutureBuilder(
  ///       future: obj.future,
  ///       builder: (_, snapshot) {
  ///       // return future result
  ///     });
  ///   }
  ///   else {
  ///     // return const value
  ///   }
  /// }
  /// ```

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
