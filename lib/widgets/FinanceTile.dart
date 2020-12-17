import 'package:budgetour/objects/FinanceObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject tile;

  FinanceTile(this.tile);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorGenerator.fromHex('#FCFCFC'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
        side: BorderSide(
            style: BorderStyle.solid,
            width: 1,
            color: ColorGenerator.fromHex('#DCDCDC')),
      ),
      margin: EdgeInsets.all(8.0),
      child: buildContents(),
    );
  }

  Column buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(leading: Text(tile.title), trailing: Icon(Icons.drag_handle),),
        Text(tile.label_1 ?? ''),
        Text(tile.label_2 ?? ''),
      ],
    );
  }
}
